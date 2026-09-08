#!/bin/sh

set -e

echo "=== Running gitleaks pre-commit hook tests ==="

# 1. Setup temp repo
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR=$(mktemp -d)
trap 'rm -rf "$REPO_DIR"' EXIT HUP INT TERM
echo "Setting up temporary Git repository in $REPO_DIR"
cd "$REPO_DIR"
git init >/dev/null 2>&1
git config user.name "Test User"
git config user.email "test@example.com"

# Copy the hook
mkdir -p .git/hooks
cp "$REPO_ROOT/.githooks/pre-commit" .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Helper function to clear mock
clear_mock() {
    rm -f bin/gitleaks
    export PATH=$ORIGINAL_PATH
}

ORIGINAL_PATH=$PATH

echo ""
echo "--- TEST 1: Missing scanner rejects (fails closed) ---"
clear_mock
# Ensure gitleaks is not in PATH by prepending an empty bin or we just rely on it not being installed
export PATH="/usr/bin:/bin"
echo "clean content" > file.txt
git add file.txt
if git commit -m "Test commit" >/dev/null 2>&1; then
    echo "FAIL: Commit succeeded despite missing gitleaks"
    exit 1
else
    echo "PASS: Commit rejected when gitleaks is missing"
fi

echo ""
echo "--- TEST 2: Clean staged content passes ---"
# Create a mocked gitleaks binary that exits 0
mkdir -p bin
cat << 'EOF' > bin/gitleaks
#!/bin/sh
printf '%s\n' "$*" > "$GITLEAKS_ARGS_FILE"
exit "$GITLEAKS_EXIT_CODE"
EOF
chmod +x bin/gitleaks
export PATH="$PWD/bin:$ORIGINAL_PATH"
export GITLEAKS_ARGS_FILE="$REPO_DIR/gitleaks-args"
export GITLEAKS_EXIT_CODE=0

echo "clean content 2" > file2.txt
git add file2.txt
if git commit -m "Test clean commit" >/dev/null 2>&1; then
    echo "PASS: Commit succeeded with clean content"
else
    echo "FAIL: Commit rejected despite clean content"
    exit 1
fi
if [ "$(cat "$GITLEAKS_ARGS_FILE")" = "protect --staged --verbose --redact" ]; then
    echo "PASS: Hook invokes gitleaks protect with staged and redaction flags"
else
    echo "FAIL: Hook invoked gitleaks with unexpected arguments"
    exit 1
fi

echo ""
echo "--- TEST 3: Secret-like staged content is rejected ---"
# Make the mock report a detected secret without printing a value.
export GITLEAKS_EXIT_CODE=1

echo "secret_key = XYZ123" > secret.txt
git add secret.txt
if git commit -m "Test secret commit" >/dev/null 2>&1; then
    echo "FAIL: Commit succeeded despite secret content"
    exit 1
else
    echo "PASS: Commit rejected with secret content"
fi

echo ""
echo "--- TEST 4: Setup refuses to overwrite pre-existing custom hooks path ---"
cp "$REPO_ROOT/Makefile" .
git config --local core.hooksPath ".custom_hooks"
if make init-githooks >/dev/null 2>&1; then
    echo "FAIL: init-githooks overwrote pre-existing custom hooks path"
    exit 1
else
    if [ "$(git config --local core.hooksPath)" = ".custom_hooks" ]; then
        echo "PASS: init-githooks refused to overwrite custom hooks path"
    else
        echo "FAIL: core.hooksPath was changed unexpectedly"
        exit 1
    fi
fi

echo ""
echo "--- TEST 4.1: Setup refuses to overwrite pre-existing global hooks path ---"
git config --local --unset core.hooksPath || true
export GIT_CONFIG_GLOBAL="$REPO_DIR/global_gitconfig"
git config --global core.hooksPath ".global_hooks"
if make init-githooks >/dev/null 2>&1; then
    echo "FAIL: init-githooks overwrote pre-existing global hooks path"
    exit 1
else
    if git config --local core.hooksPath >/dev/null 2>&1; then
        echo "FAIL: core.hooksPath was changed locally unexpectedly"
        exit 1
    else
        echo "PASS: init-githooks refused to overwrite global hooks path"
    fi
fi
git config --global --unset core.hooksPath
unset GIT_CONFIG_GLOBAL

echo ""
echo "--- TEST 5: Setup and restore work cleanly on default paths ---"
git config --local --unset core.hooksPath || true
if ! make init-githooks >/dev/null 2>&1; then
    echo "FAIL: init-githooks failed on empty hooks path"
    exit 1
fi
if [ "$(git config --local core.hooksPath)" != ".githooks" ]; then
    echo "FAIL: init-githooks did not set correct hooks path"
    exit 1
fi
if ! make restore-githooks >/dev/null 2>&1; then
    echo "FAIL: restore-githooks failed"
    exit 1
fi
if git config --local core.hooksPath >/dev/null 2>&1; then
    echo "FAIL: restore-githooks did not unset the hooks path"
    exit 1
else
    echo "PASS: Setup and restore succeed and clean up properly"
fi

echo ""
echo "=== All tests passed! ==="

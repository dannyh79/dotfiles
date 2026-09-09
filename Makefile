.PHONY: all
all: init-config init-git init-githooks init-homebrew init-asdf init-tmux init-zsh init-omp

# Restores in the opposite sequence of init's
.PHONY: restore
restore: restore-omp restore-zsh restore-tmux restore-asdf restore-githooks restore-git restore-config

.PHONY: init-config
init-config:
	@if [ -L $$HOME/.config ] && [ "$$(readlink $$HOME/.config)" = "$$(pwd -P)" ]; then \
		:; \
	elif [ -e $$HOME/.config ] || [ -L $$HOME/.config ]; then \
		echo "Moving ~/.config to ~/.config.orig ..."; \
		mv $$HOME/.config $$HOME/.config.orig; \
	fi
	@echo "Symlinking $$(pwd -P) to ~/.config ..."
	@ln -sfn $$(pwd -P) $$HOME/.config

.PHONY: restore-config
restore-config:
	@echo "Restoring ~/.config ..."
	@rm -rf $$HOME/.config
	@if [ -e $$HOME/.config.orig ]; then \
		mv $$HOME/.config.orig $$HOME/.config; \
	fi

.PHONY: init-git
init-git:
	@if [ -L $$HOME/.gitconfig ] && [ "$$(readlink $$HOME/.gitconfig)" = "$$(pwd -P)/git/gitconfig" ]; then \
		:; \
	elif [ -e $$HOME/.gitconfig ] || [ -L $$HOME/.gitconfig ]; then \
		echo "Moving ~/.gitconfig to ~/.gitconfig.bk ..."; \
		mv $$HOME/.gitconfig $$HOME/.gitconfig.bk; \
	fi
	@echo "Symlinking git/gitconfig to ~/.gitconfig ..."
	@ln -sfn $$(pwd -P)/git/gitconfig $$HOME/.gitconfig

.PHONY: restore-git
restore-git:
	@echo "Restoring ~/.gitconfig ..."
	@rm -f $$HOME/.gitconfig
	@if [ -e $$HOME/.gitconfig.bk ]; then \
		mv $$HOME/.gitconfig.bk $$HOME/.gitconfig; \
	fi

.PHONY: init-githooks
init-githooks:
	@current_hooks=$$(git config core.hooksPath || true); \
	if [ -n "$$current_hooks" ] && [ "$$current_hooks" != ".githooks" ]; then \
		echo "ERROR: core.hooksPath is already set to '$$current_hooks'. Refusing to overwrite."; \
		exit 1; \
	fi
	@echo "Setting core.hooksPath to .githooks ..."
	@git config --local core.hooksPath .githooks

.PHONY: restore-githooks
restore-githooks:
	@current_hooks=$$(git config --local core.hooksPath || true); \
	if [ "$$current_hooks" = ".githooks" ]; then \
		echo "Restoring core.hooksPath to default ..."; \
		git config --local --unset core.hooksPath || true; \
	else \
		echo "core.hooksPath is not '.githooks' (found: '$$current_hooks'). Skipping restore."; \
	fi

.PHONY: init-homebrew
init-homebrew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew not found; installing ..."; \
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash; \
	else \
		echo "Dumping current brew packages to Brewfile.bk ..."; \
		brew bundle dump --file=homebrew/Brewfile.bk --force; \
	fi
	@echo "Installing packages from homebrew/Brewfile ..."
	@PATH="/opt/homebrew/bin:/usr/local/bin:$$PATH" brew bundle --file=homebrew/Brewfile

.PHONY: restore-homebrew
restore-homebrew:
	@echo "Uninstalling all currently installed Homebrew packages ..."
	@brew list | xargs brew uninstall --ignore-dependencies --force || true
	@echo "Installing packages from homebrew/Brewfile.bk ..."
	@PATH="/opt/homebrew/bin:/usr/local/bin:$$PATH" brew bundle --file=homebrew/Brewfile.bk

.PHONY: init-tmux
init-tmux:
	@if [ -L $$HOME/.tmux.conf ] && [ "$$(readlink $$HOME/.tmux.conf)" = "$$(pwd -P)/tmux/tmux.conf" ]; then \
		:; \
	elif [ -e $$HOME/.tmux.conf ] || [ -L $$HOME/.tmux.conf ]; then \
		echo "Moving ~/.tmux.conf to ~/.tmux.conf.bk ..."; \
		mv $$HOME/.tmux.conf $$HOME/.tmux.conf.bk; \
	fi
	@echo "Symlinking tmux/tmux.conf to ~/.tmux.conf ..."
	@ln -sfn $$(pwd -P)/tmux/tmux.conf $$HOME/.tmux.conf
	@echo "Installing tmux plugins using TPM ..."
	@if [ ! -d $$HOME/.tmux/plugins/tpm ]; then \
		git clone https://github.com/tmux-plugins/tpm $$HOME/.tmux/plugins/tpm; \
	fi
	@$$HOME/.tmux/plugins/tpm/bin/install_plugins

.PHONY: restore-tmux
restore-tmux:
	@echo "Restoring ~/.tmux.conf ..."
	@rm -f $$HOME/.tmux.conf
	@if [ -e $$HOME/.tmux.conf.bk ]; then \
		mv $$HOME/.tmux.conf.bk $$HOME/.tmux.conf; \
	fi

.PHONY: init-zsh
init-zsh:
	@if [ -L $$HOME/.zshrc ] && [ "$$(readlink $$HOME/.zshrc)" = "$$(pwd -P)/zsh/zshrc" ]; then \
		:; \
	elif [ -e $$HOME/.zshrc ] || [ -L $$HOME/.zshrc ]; then \
		echo "Moving ~/.zshrc to ~/.zshrc.bk ..."; \
		mv $$HOME/.zshrc $$HOME/.zshrc.bk; \
	fi
	@echo "Symlinking zsh/zshrc to ~/.zshrc ..."
	@ln -sfn $$(pwd -P)/zsh/zshrc $$HOME/.zshrc
	@echo "Sourcing ~/.zshrc ..."
	@zsh -c "source $$HOME/.zshrc"

.PHONY: restore-zsh
restore-zsh:
	@echo "Restoring ~/.zshrc ..."
	@rm -f $$HOME/.zshrc
	@if [ -e $$HOME/.zshrc.bk ]; then \
		mv $$HOME/.zshrc.bk $$HOME/.zshrc; \
	fi

.PHONY: init-asdf
init-asdf:
	@if [ -L $$HOME/.tool-versions ] && [ "$$(readlink $$HOME/.tool-versions)" = "$$(pwd -P)/asdf/tool-versions" ]; then \
		:; \
	elif [ -e $$HOME/.tool-versions ] || [ -L $$HOME/.tool-versions ]; then \
		echo "Moving ~/.tool-versions to ~/.tool-versions.bk ..."; \
		mv $$HOME/.tool-versions $$HOME/.tool-versions.bk; \
	fi
	@echo "Symlinking asdf/tool-versions to ~/.tool-versions ..."
	@ln -sfn $$(pwd -P)/asdf/tool-versions $$HOME/.tool-versions
	@echo "Adding asdf plugins ..."
	@cut -d' ' -f1 $$HOME/.tool-versions | xargs -I {} asdf plugin add {} 2>/dev/null || true
	@echo "Installing asdf tools ..."
	@asdf install

.PHONY: restore-asdf
restore-asdf:
	@echo "Restoring ~/.tool-versions ..."
	@rm -f $$HOME/.tool-versions
	@if [ -e $$HOME/.tool-versions.bk ]; then \
		mv $$HOME/.tool-versions.bk $$HOME/.tool-versions; \
	fi

.PHONY: init-omp
init-omp:
	@echo "Setting up omp configuration ..."
	@mkdir -p $$HOME/.omp/agent
	@if [ -e $$HOME/.omp/agent/config.yml ] && [ ! -L $$HOME/.omp/agent/config.yml ]; then \
		echo "Backing up existing omp config.yml ..."; \
		mv $$HOME/.omp/agent/config.yml $$HOME/.omp/agent/config.yml.bk; \
	fi
	@ln -sfn $$(pwd -P)/omp/agent/config.yml $$HOME/.omp/agent/config.yml
	@if [ -d $$(pwd -P)/omp/agent/extensions ]; then \
		if [ -e $$HOME/.omp/agent/extensions ] && [ ! -L $$HOME/.omp/agent/extensions ]; then \
			echo "Backing up existing omp extensions ..."; \
			mv $$HOME/.omp/agent/extensions $$HOME/.omp/agent/extensions.bk; \
		fi; \
		ln -sfn $$(pwd -P)/omp/agent/extensions $$HOME/.omp/agent/extensions; \
	fi
	@echo "Installing omp plugins dependencies ..."
	@cd $$(pwd -P)/omp/plugins && bun install
	@echo "Linking omp plugins ..."
	@omp plugin link $$(pwd -P)/omp/plugins

.PHONY: restore-omp
restore-omp:
	@echo "Restoring omp configuration ..."
	@rm -f $$HOME/.omp/agent/config.yml
	@if [ -e $$HOME/.omp/agent/config.yml.bk ]; then \
		mv $$HOME/.omp/agent/config.yml.bk $$HOME/.omp/agent/config.yml; \
	fi
	@rm -f $$HOME/.omp/agent/extensions
	@if [ -e $$HOME/.omp/agent/extensions.bk ]; then \
		mv $$HOME/.omp/agent/extensions.bk $$HOME/.omp/agent/extensions; \
	fi
	@echo "Unlinking omp plugins ..."
	@omp plugin uninstall omp-plugins || true

# To conform to https://github.com/mrtazz/checkmake's rules only
.PHONY: test
.PHONY: clean

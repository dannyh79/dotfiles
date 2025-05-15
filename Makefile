.PHONY: all
all: init-config init-git init-homebrew init-tmux init-zsh

# Restores in the opposite sequence of init's
.PHONY: restore
restore: restore-zsh restore-tmux restore-git restore-config

.PHONY: init-config
init-config:
	@if [ -e $$HOME/.config ]; then \
		echo "Moving ~/.config to ~/.config.bk ..."; \
		mv $$HOME/.config $$HOME/.config.bk; \
	fi
	@echo "Symlinking $$PWD to ~/.config ..."
	@ln -sfn $(PWD) $$HOME/.config

.PHONY: restore-config
restore-config:
	@echo "Restoring ~/.config ..."
	@rm -rf $$HOME/.config
	@if [ -e $$HOME/.config.bk ]; then \
		mv $$HOME/.config.bk $$HOME/.config; \
	fi

.PHONY: init-git
init-git:
	@if [ -e $$HOME/.gitconfig ]; then \
		echo "Moving ~/.gitconfig to ~/.gitconfig.bk ..."; \
		mv $$HOME/.gitconfig $$HOME/.gitconfig.bk; \
	fi
	@echo "Symlinking git/gitconfig to ~/.gitconfig ..."
	@ln -sfn $(PWD)/git/gitconfig $$HOME/.gitconfig

.PHONY: restore-git
restore-git:
	@echo "Restoring ~/.gitconfig ..."
	@rm -f $$HOME/.gitconfig
	@if [ -e $$HOME/.gitconfig.bk ]; then \
		mv $$HOME/.gitconfig.bk $$HOME/.gitconfig; \
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
	@brew bundle --file=homebrew/Brewfile

.PHONY: restore-homebrew
restore-homebrew:
	@echo "Uninstalling all currently installed Homebrew packages ..."
	@brew list | xargs brew uninstall --force || true
	@echo "Installing packages from homebrew/Brewfile.bk ..."
	@brew bundle --file=homebrew/Brewfile.bk

.PHONY: init-tmux
init-tmux:
	@if [ -e $$HOME/.tmux.conf ]; then \
		echo "Moving ~/.tmux.conf to ~/.tmux.conf.bk ..."; \
		mv $$HOME/.tmux.conf $$HOME/.tmux.conf.bk; \
	fi
	@echo "Symlinking tmux/tmux.conf to ~/.tmux.conf ..."
	@ln -sfn $(PWD)/tmux/tmux.conf $$HOME/.tmux.conf
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
	@if [ -e $$HOME/.zshrc ]; then \
		echo "Moving ~/.zshrc to ~/.zshrc.bk ..."; \
		mv $$HOME/.zshrc $$HOME/.zshrc.bk; \
	fi
	@echo "Symlinking zsh/zshrc to ~/.zshrc ..."
	@ln -sfn $(PWD)/zsh/zshrc $$HOME/.zshrc
	@echo "Sourcing ~/.zshrc ..."
	@zsh -c "source $$HOME/.zshrc"

.PHONY: restore-zsh
restore-zsh:
	@echo "Restoring ~/.zshrc ..."
	@rm -f $$HOME/.zshrc
	@if [ -e $$HOME/.zshrc.bk ]; then \
		mv $$HOME/.zshrc.bk $$HOME/.zshrc; \
	fi

# To conform to https://github.com/mrtazz/checkmake's rules only
.PHONY: test
.PHONY: clean

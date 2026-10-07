CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitignore .gitmodules .travis.yml .zsh_alias .zshrc .vimrc
DOTFILES := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
INSTALLERS := $(wildcard ./scripts/*sh)

# Make Homebrew installed by 05_brew.sh visible to the following installers on a fresh machine
export PATH := /opt/homebrew/bin:/opt/homebrew/sbin:$(PATH)

.PHONY: list
list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create symlink to home directory
	@echo 'Copyright (c) 2021 Shin Ando All Rights Reserved.'
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfvn $(abspath $(val)) $(HOME)/$(val);)

update: ## Fetch changes for this repo
	git pull origin master

push: ## Push changes to master
	git push origin master

check-role: ## Require ROLE=client|server
	@case "$(ROLE)" in client|server) ;; *) echo 'ERROR: ROLE must be client or server (e.g. make install ROLE=server)' >&2; exit 1;; esac

init: check-role
	@$(foreach val, $(INSTALLERS), ROLE=$(ROLE) sh $(val);)

install: init deploy
	@exec $$SHELL


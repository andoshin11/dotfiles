CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
INSTALLERS := $(wildcard ./scripts/*sh)

.PHONY: list
list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create symlink to home directory
	@echo 'Copyright (c) 2018 Shin Ando All Rights Reserved.'
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfvn $(abspath $(val)) $(HOME)/$(val);)

update: ## Fetch changes for this repo
	git pull origin master

push: ## Push changes to master
	git push origin master

init:
	@$(foreach val, $(INSTALLERS), sh $(val);)

install: init deploy
	@exec $$SHELL


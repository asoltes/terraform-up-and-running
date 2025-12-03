# Makefile
.PHONY: setup hooks

setup: hooks

hooks:
	pre-commit install
	pre-commit autoupdate
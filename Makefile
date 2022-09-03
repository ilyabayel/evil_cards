.PHONY: install ui core
SHELL := /bin/bash
MIX := cd packages/core; mix

install:
	cd packages/core; [ -f ./boilerplate.exs ] && elixir ./boilerplate.exs
	$(MIX) deps.get
	cd packages/ui; yarn
	$(MIX) ecto.create
	$(MIX) test

dev: 
	make -j 2 ui core

ui:
	cd packages/ui; yarn dev

core:
	$(MIX) phx.server

test:
	$(MIX) test

coverage:
	$(MIX) test --cover
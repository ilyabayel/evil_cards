.PHONY: install ui api
SHELL := /bin/bash
CONCURRENTLY := ./packages/ui/node_modules/.bin/concurrently
MIX := cd packages/core; mix

install:
	cd packages/core; [ -f ./boilerplate.exs ] && elixir ./boilerplate.exs
	$(MIX) deps.get
	cd packages/ui; yarn
	$(MIX) ecto.create
	$(MIX) test

dev:
	$(CONCURRENTLY) \
		-n api,ui \
		"$(MIX) phx.server" \
		"cd packages/ui; yarn dev" \
		-c "bgGreen.bold,bgCyan.bold"

ui:
	cd packages/ui; yarn dev

api:
	$(MIX) phx.server

test:
	$(MIX) test

coverage:
	$(MIX) test --cover
.PHONY: install ui core
SHELL := /bin/bash
CONCURRENTLY := ./packages/ui/node_modules/.bin/concurrently
MIX := cd packages/core; mix

install:
	cd packages/core; [ -f ./boilerplate.exs ] && elixir ./boilerplate.exs
	$(MIX) deps.get
	cd packages/ui; yarn
	$(MIX) ecto.create
	$(MIX) test

dev: ui core

ui:
	cd packages/ui; yarn dev

core:
	$(MIX) phx.server

test:
	$(MIX) test

coverage:
	$(MIX) test --cover
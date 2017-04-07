all:		build

build:	src/**/*.cr
				shards build --release

.PHONY: web
web:
				crystal run src/boot.cr -- web

.PHONY: worker
worker:
				crystal run src/boot.cr -- worker --debug

prepare: ./lib/sentry/src/sentry_cli.cr
				mkdir -p ./bin/
				crystal build --release ./lib/sentry/src/sentry_cli.cr -o ./bin/sentry
				@echo "Sentry compiled to ./bin/sentry"

tag: shard.yml
				git tag `crystal src/parse_version.cr`

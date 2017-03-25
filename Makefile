all:		build

build:	src/**/*.cr
				shards build --release

web:
				crystal run src/boot.cr -- web

worker:
				crystal run src/boot.cr -- worker --debug

prepare:
				mkdir -p ./bin/
				crystal build --release ./lib/sentry/src/sentry_cli.cr -o ./bin/sentry
				@echo "Sentry compalied to ./bin/sentry"

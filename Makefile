all:		build

build:	src/**/*.cr
				shards build --release
## crystal build --release --cross-compile --target "x86_64-unknown-linux-gnu" src/boot.cr -o craigmon-linux.o
## cc craigmon-linux.o -o craigmon-linux -lpcre -lrt -lm -lgc -lunwind
## rm craigmon-linux.o

web:
				crystal run src/boot.cr -- web

worker:
				crystal run src/boot.cr -- worker --debug

prepare:
				mkdir -p ./bin/
				crystal build --release ./lib/sentry/src/sentry_cli.cr -o ./bin/sentry
				@echo "Sentry compalied to ./bin/sentry"

upload:
				rsync -azv --exclude=".git" --exclude="bin" --exclude=".shards" --exclude="lib" . $RADDRESS:/tmp/craigmon

tag:
				git tag `crystal src/parse_version.cr`

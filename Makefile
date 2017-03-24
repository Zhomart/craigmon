all:		build

build:	src/**/*.cr
				shards build --release

web:
				crystal run src/boot.cr -- web

worker:
				crystal run src/boot.cr -- worker --debug

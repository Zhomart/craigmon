all:		build

build:	src/**/*.cr
				shards build --release

web:
				crystal run src/craig_mon.cr -- web

worker:
				crystal run src/craig_mon.cr -- worker

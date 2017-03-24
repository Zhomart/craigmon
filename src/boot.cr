ENV["SQLITE3_PATH"] = "sqlite3://craigmon.db"
require "./craig_mon"

CraigMon::Cli.run

require "option_parser"
require "db"
require "sqlite3"

module CraigMon
  module Cli
    extend self

    def run
      command = nil

      OptionParser.parse! do |parser|
        parser.banner = "Usage: craigmon [arguments] web|worker"
        parser.on("-h", "--help", "Show this help") { puts parser }
        parser.unknown_args { |args, _|  command = args.first if args.size > 0 }
      end

      case command
      when "web" then run_command { CraigMon::Web.run }
      when "worker" then run_command { CraigMon::Worker.run }
      else
        puts "No command provided. Try 'craigmon --help' for more information."
        exit(1)
      end
    end

    private def run_command(&block)
      setup()
      yield
      finish()
    end

    private def setup
      CraigMon.db = DB.open("sqlite3:craigmon.db")

      CraigMon.db.exec "CREATE TABLE IF NOT EXISTS urls (id int, name varchar(30), url varchar(420))"
    end

    private def finish
      CraigMon.db.close
    end

  end
end

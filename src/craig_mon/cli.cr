require "option_parser"

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
      when "web" then CraigMon::Web.run
      when "worker" then CraigMon::Worker.run
      else
        puts "No command provided. Try 'craigmon --help' for more information."
        exit(1)
      end
    end

  end
end

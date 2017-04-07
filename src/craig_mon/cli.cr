module CraigMon
  module Cli
    extend self

    def run
      if ARGV.size < 1
        puts "No command provided. Try 'craigmon --help' for more information."
        exit(1)
      elsif ARGV == ["--help"] || ARGV == ["-h"]
        puts "Usage: craigmon web|worker [arguments]"
        exit
      end

      case ARGV[0]
      when "web"       then run_command { CraigMon::Web.run }
      when "worker"    then run_command { CraigMon::Worker.run }
      when "--version" then show_version
      when "-v"        then show_version
      else
        puts "Unknown command. Try 'craigmon --help' for more information."
        exit(1)
      end
    end

    private def show_version
      puts CraigMon::VERSION
    end

    private def run_command(&block)
      setup()
      yield
      finish()
    end

    private def setup
      Database.setup
    end

    private def finish
      Database.finish
    end
  end
end

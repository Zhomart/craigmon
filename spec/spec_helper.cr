require "spec"
require "faker"

ENV["SQLITE3_PATH"] = "sqlite3://craigmon.test.db"
require "../src/craig_mon"

require "./helpers"

module SpecHelper

  def self.setup
    CraigMon::Database.setup
  end

  def self.root : String
    @@root ||= File.expand_path("../..", __FILE__)
  end

end

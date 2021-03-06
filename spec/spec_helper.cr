require "spec"
require "faker"
require "webmock"

ENV["SQLITE3_PATH"] = "sqlite3://craigmon.test.db"
require "../src/craig_mon"

require "./helpers"

WebMock.allow_net_connect = true

module SpecHelper

  def self.setup
    CraigMon::Database.setup
  end

  def self.root : String
    @@root ||= File.expand_path("../..", __FILE__)
  end

end

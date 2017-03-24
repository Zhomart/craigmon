require "sqlite3"
require "crecto"
require "logger"
require "./craig_mon/*"

module CraigMon

  def self.logger=(l : Logger)
    @@logger = l
  end

  def self.logger : Logger
    @@logger.as(Logger)
  end

end

CraigMon.logger = Logger.new(STDOUT)
CraigMon.logger.level = Logger::INFO

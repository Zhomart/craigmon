require "./craig_mon/*"
require "logger"

module CraigMon

  def self.db=(db : DB::Database)
    @@db = db
  end

  def self.db : DB::Database
    @@db.as(DB::Database)
  end

  def self.logger=(l : Logger)
    @@logger = l
  end

  def self.logger : Logger
    @@logger.as(Logger)
  end

end

CraigMon.logger = Logger.new(STDOUT)
CraigMon.logger.level = Logger::INFO

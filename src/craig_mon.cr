require "./craig_mon/*"

module CraigMon

  def self.db=(db : DB::Database)
    @@db = db
  end

  def self.db : DB::Database
    @@db.as(DB::Database)
  end

end

CraigMon::Cli.run

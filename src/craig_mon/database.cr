module CraigMon::Database

  def self.setup
    Crecto::Repo::ADAPTER.get_db.exec "
      CREATE TABLE IF NOT EXISTS urls(
        id INTEGER NOT NULL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        url VARCHAR(255) NOT NULL,
        created_at TEXT,
        updated_at TEXT
      )
    "
  end

  def self.finish
  end

end

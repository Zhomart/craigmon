module CraigMon::Database

  def self.setup
    Crecto::Repo::ADAPTER.get_db.exec "
      CREATE TABLE IF NOT EXISTS urls (
        id INTEGER NOT NULL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        url VARCHAR(255) NOT NULL,
        created_at DATETIME,
        updated_at DATETIME
      );
    "

    Crecto::Repo::ADAPTER.get_db.exec "
      CREATE TABLE IF NOT EXISTS items (
        id INTEGER NOT NULL PRIMARY KEY,
        uid BIGINT NOT NULL UNIQUE,
        title VARCHAR(255) NOT NULL,
        link VARCHAR(255) NOT NULL,
        description TEXT,
        date DATETIME NOT NULL,
        issued DATETIME NOT NULL,
        vanished_at DATETIME,
        comment TEXT,
        picture_urls TEXT,
        search_url VARCHAR(255) NOT NULL,
        price float,
        created_at DATETIME,
        updated_at DATETIME
      );
    "
  end

  def self.finish
  end

end

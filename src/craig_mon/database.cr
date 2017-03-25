module CraigMon::Database

  def self.setup
    Crecto::Repo::ADAPTER.get_db.exec "
      CREATE TABLE IF NOT EXISTS searches (
        id INTEGER NOT NULL PRIMARY KEY,
        name VARCHAR(255) NOT NULL UNIQUE,
        url VARCHAR(255) NOT NULL,
        active bool,
        crawled_at DATETIME,
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
        search_id INTEGER NOT NULL REFERENCES searches(id),
        created_at DATETIME,
        updated_at DATETIME
      );
    "
  end

  def self.finish
  end

end

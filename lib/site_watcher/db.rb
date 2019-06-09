require "sqlite3"
require "date"

module SiteWatcher
  class DB
    def initialize
      db_dir = "#{Dir.home}/.config/site_watcher"
      Dir.mkdir(db_dir) unless Dir.exist?(db_dir)
      @sqlite = SQLite3::Database.new "#{db_dir}/db#{ENV["ENV"]}.sqlite3"
      @sqlite.results_as_hash = true
    end

    def setup
      sites_table = @sqlite.execute "SELECT name FROM sqlite_master WHERE type='table' AND name='sites'"
      if sites_table.empty?
        @sqlite.execute "PRAGMA foreign_keys=true"
        @sqlite.execute <<-SQL
          CREATE table sites (
            id integer primary key,
            name varchar(100) not null unique,
            url varchar(100) not null,
            csspath varchar(100) not null
          )
        SQL
        @sqlite.execute <<-SQL
          CREATE table site_modifications (
            id integer primary key,
            site_id integer not null,
            content string not null,
            created_at string not null,
            foreign key (site_id) references sites(id)
          )
        SQL
        puts "Created db"
      else
        puts "Already exists"
      end
    end

    def create_site(name, url, csspath)
      @sqlite.execute "INSERT INTO sites(name, url, csspath) VALUES (?, ?, ?)", [name, url, csspath]
    end

    def get_site_by_name(name)
      @sqlite.execute("SELECT * FROM sites WHERE name = ?", [name])[0]
    end

    def list_sites
      @sqlite.execute "SELECT * FROM sites"
    end

    def sites_count
      @sqlite.execute("SELECT COUNT(*) FROM sites")[0]["COUNT(*)"]
    end

    def remove_site(name)
      @sqlite.execute "DELETE FROM sites WHERE name = ?", [name]
    end

    # modifications
    def latest_modification(site)
      @sqlite.execute("SELECT * FROM site_modifications WHERE site_id = ? ORDER BY created_at DESC LIMIT 1", [site["id"]])[0]
    end

    def create_modification(site, content)
      latest = latest_modification(site)
      return if !latest.nil? and latest["content"] == content

      now = DateTime.now.to_s
      @sqlite.execute "INSERT INTO site_modifications(site_id, content, created_at) VALUES(?, ?, ?)", [site["id"], content, now]
    end

    def diff_modification(site, num)
      @sqlite.execute "SELECT * FROM site_modifications WHERE site_id = ? ORDER BY created_at DESC LIMIT ?", [site["id"], num]
    end
  end
end

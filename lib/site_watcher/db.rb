require "sqlite3"

module SiteWatcher
  class DB
    def initialize
      @sqlite = SQLite3::Database.new "#{Dir.home}/.config/site_watcher/db#{ENV["ENV"]}.sqlite3"
      @sqlite.results_as_hash = true
    end

    def setup
      sites_table = @sqlite.execute "SELECT name FROM sqlite_master WHERE type='table' AND name='sites'"
      if sites_table.empty?
        @sqlite.execute <<-SQL
          CREATE table sites (
            id integer primary key,
            name varchar(100) unique,
            url varchar(100),
            csspath varchar(100)
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

    def remove_all_sites
      @sqlite.execute <<-SQL
        DELETE FROM sites;
        DELETE FROM sqlite_sequence WHERE name = sites;
        VACUUM;
      SQL
    end
  end
end

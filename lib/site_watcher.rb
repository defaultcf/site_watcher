require "site_watcher/version"
require "site_watcher/scrape"
require "site_watcher/db"
require "thor"

module SiteWatcher
  class Error < StandardError; end

  class CLI < Thor
    def initialize(*args)
      super(*args)
      @db = DB.new
    end

    desc "setup", "Setup site_watcher"
    def setup
      @db.setup
    end

    desc "add NAME URL CSSPATH", "Add monitored site"
    def add(name, url, csspath)
      @db.create_site(name, url, csspath)
      check(name)
    end

    desc "list", "List monitored sites"
    def list
      puts @db.list_sites
    end

    desc "check", "Check monitored sites"
    def check(name)
      site = @db.get_site_by_name(name)
      scraping = Scraping.new
      puts scraping.get_content(site["url"], site["csspath"])
      scraping.driver.quit
    end

    desc "remove NAME", "Remove monitored site"
    def remove(name)
      @db.remove_site(name)
    end
  end
end

require "site_watcher/version"
require "scrape"
require "thor"

module SiteWatcher
  class Error < StandardError; end

  class CLI < Thor
    desc "add NAME URL CSSPATH", "Add monitored site"
    def add(name, url, csspath)
      scraping = Scraping.new
      puts scraping.get_content(url, csspath)
      scraping.driver.quit
    end

    desc "list", "List monitored sites"
    def list
      puts "List"
    end

    desc "check", "Check monitored sites"
    def check
      puts "Check"
    end

    desc "remove NAME", "Remove monitored site"
    def remove(name)
      puts "Remove #{name}"
    end
  end
end

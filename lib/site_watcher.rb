require "site_watcher/version"
require "site_watcher/scrape"
require "site_watcher/db"
require "thor"
require "diffy"

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

    desc "check NAME", "Check monitored sites"
    def check(name)
      site = @db.get_site_by_name(name)
      scraping = Scraping.new
      content = scraping.get_content(site["url"], site["csspath"])
      scraping.driver.quit

      @db.create_modification(site, content)
      puts content
    end

    desc "checkall", "Check all monitored sites"
    def checkall
      @db.list_sites.map do |site|
        check(site["name"])
      end
    end

    desc "diff NAME", "Show diff"
    def diff(name, num = 1)
      num = num.to_i
      site = @db.get_site_by_name(name)
      mods = @db.diff_modification(site, num + 1)
      return if mods.length < 2
      Diffy::Diff.default_format = :color
      Diffy::Diff.new(mods[num]["content"] + "\n", mods[0]["content"] + "\n").each do |line|
        case line
        when /^\+/ then
          puts "created_at: #{mods[0]['created_at']}"
          puts "\e[32;1m#{line.chomp}\e[m"
        when /^\-/ then
          puts "created_at: #{mods[num]['created_at']}"
          puts "\e[31;1m#{line.chomp}\e[m"
        end
        puts "\n"
      end
    end

    desc "remove NAME", "Remove monitored site"
    def remove(name)
      @db.remove_site(name)
    end
  end
end

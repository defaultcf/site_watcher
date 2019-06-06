require "site_watcher/version"
require "thor"

module SiteWatcher
  class Error < StandardError; end

  class CLI < Thor
    desc "add NAME URL CSSPATH", "Add monitored site"
    def add(name, url, csspath)
      puts "Add #{name}"
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

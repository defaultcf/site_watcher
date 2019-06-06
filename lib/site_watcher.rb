require "site_watcher/version"
require "thor"

module SiteWatcher
  class Error < StandardError; end

  class CLI < Thor
    desc "add SITE_NAME", "Add monitored site"
    def add(name)
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

    desc "remove SITE_NAME", "Remove monitored site"
    def remove(name)
      puts "Remove #{name}"
    end
  end
end

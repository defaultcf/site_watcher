require "selenium-webdriver"

class Scraping
  attr_reader :driver

  def initialize
    caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {
      binary: "/usr/bin/google-chrome-stable",
      args: ["--headless", "--disable-gpu"],
    })
    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
  end

  def get_content(url, csspath)
    @driver.navigate.to url
    @driver.find_element(:css, csspath).text
  end
end

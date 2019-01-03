require 'selenium-webdriver'

module Navegador
  class Firefox
    def initialize
      profile                       = Selenium::WebDriver::Firefox::Profile.new
      profile["network.proxy.type"] = 0

      $browser = Watir::Browser.new(:firefox, profile: profile)
    end
  end

end
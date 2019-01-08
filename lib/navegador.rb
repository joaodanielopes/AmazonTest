require 'selenium-webdriver'

module Navegador
  class Firefox
    def initialize
      profile                                     = Selenium::WebDriver::Firefox::Profile.new
      profile["network.proxy.type"]               = 0

      $use_headless                               = false
      if $use_headless
        headless = Headless.new({ :display    => rand(10000),
                                  :dimensions => "#{1680}x#{1050}x#{24}",
                                  :video      => {
                                    :frame_rate => 12,
                                    :codec      => 'libx264',
                                    :provider   => 'ffmpeg' } })
        headless.start
        $browser          = BrowserWrapper.new(:firefox, profile: profile)
        $browser.headless = headless
        # $browser.headless.video.start_capture
      else
        $browser = Watir::Browser.new(:firefox, profile: profile)
      end
    end
  end

  class BrowserWrapper < Watir::Browser
    attr_accessor :headless

    def close
      super
      # headless.video.stop_and_save("./scenario.mp4") if headless.video.capture_running?
      headless.destroy unless headless.nil?
      return true
    end
  end
end
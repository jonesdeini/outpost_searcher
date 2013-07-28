require "capybara"
require "capybara/poltergeist"
require "capybara/dsl"

Capybara.app_host = "http://tf2outpost.com"
Capybara.javascript_driver = :poltergeist
Capybara.run_server = false

load "secret_info.rb"

class Main

  include Capybara::DSL

  def self.go!(steam_id)
    @session = Capybara::Session.new(:poltergeist)
    if login
    # search(steam_id)
    end
  end

  def self.login
    @session.visit("/login")
    @session.fill_in("username", :with => STEAM_USER)
    @session.fill_in("password", :with => STEAM_PASS)
    unless @session.page.contains("Error verifying humanity")
      @session.click_on("imageLogin")
      sleep 4
      # assert logged in somehow
      @session.save_screenshot('screenshot.png')
      return true
    end
    false #should probably wait
  end

  def self.search(steam_id)
    @session.visit("/find")
    @session.fill_in("steamid", :with => steam_id)
    @session.click_on("submit")
    # @session.save_screenshot('screenshot.png')
  end
end

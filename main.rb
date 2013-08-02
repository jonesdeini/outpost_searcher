require "capybara"
require "capybara/poltergeist"
require "capybara/dsl"

require "pry"

Capybara.app_host = "http://tf2outpost.com"
Capybara.javascript_driver = :poltergeist
Capybara.run_server = false

require "./auth_mail"
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
    unless @session.has_content?("Error verifying humanity")
      @session.click_on("imageLogin")
      sleep 4
    end
    return true if handle_steam_guard
    false #should probably wait
  end

  def self.handle_steam_guard
    if @session.has_content?("SteamGuard")
      auth_code = AuthMail.get_two_step_auth_code
      @session.fill_in("authcode", :with => auth_code)
      @session.execute_script("SubmitAuthCode()")
      sleep 4
      @session.save_screenshot('screenshot.png')
      return true
    end
  end

  def self.search(steam_id)
    @session.visit("/find")
    @session.fill_in("steamid", :with => steam_id)
    @session.click_on("submit")
    # @session.save_screenshot('screenshot.png')
  end
end

Main.go!(nil)

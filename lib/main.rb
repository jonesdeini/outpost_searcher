require "capybara"
require "capybara/poltergeist"
require "capybara/dsl"

require "pry"

Capybara.app_host = "http://tf2outpost.com"
Capybara.javascript_driver = :poltergeist
Capybara.run_server = false

require "auth_mail"
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
    @logged_in = false
    @session.visit("/login")
    unless @session.has_content?("Error verifying humanity") #unless captcha
      @session.fill_in("username", :with => STEAM_USER)
      @session.fill_in("password", :with => STEAM_PASS)
      @session.click_on("imageLogin")
      wait_for_javascript
      handle_steam_guard
    end
    @logged_in
  end

  def self.handle_steam_guard
    if @session.has_content?("SteamGuard")
      auth_code = AuthMail.get_two_step_auth_code
      @session.fill_in("authcode", :with => auth_code)
      @session.execute_script("SubmitAuthCode()")
      wait_for_javascript
      # @session.save_screenshot('screenshot.png')
      @logged_in = true
    else
      # not sure what happens when it doesn't hit the steamguard.
      @session.save_screenshot('no_steamguard.png')
      puts @session.html
      @logged_in = true # if this works move it out of the conditional
    end
  end

  def self.search(steam_id)
    @session.visit("/find")
    @session.fill_in("steamid", :with => steam_id)
    @session.click_on("submit")
    # @session.save_screenshot('screenshot.png')
  end

  def self.wait_for_javascript
    sleep 4
  end

end

Main.go!(nil)

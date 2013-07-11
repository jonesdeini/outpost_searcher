require "capybara"
require "capybara/poltergeist"
require "capybara/dsl"

Capybara.app_host = "http://tf2outpost.com/find"
Capybara.javascript_driver = :poltergeist
Capybara.run_server = false

load "secret_info.rb"

module Main

  include Capybara::DSL

  def self.login
    session = Capybara::Session.new(:poltergeist)
    session.visit("/")
    session.fill_in "username", :with => USER
    session.fill_in "password", :with => PASS
    session.click_on "imageLogin"
    sleep 10
    session.save_screenshot('screenshot.png')
  end

end

Main.login

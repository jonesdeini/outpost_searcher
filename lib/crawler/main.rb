require "capybara"
require "capybara/poltergeist"
require "capybara/dsl"

require "pry"

Capybara.app_host = "http://tf2outpost.com"
Capybara.javascript_driver = :poltergeist
Capybara.run_server = false

require_relative "auth_mail"
require_relative "login"
require_relative "output"
require_relative "search"
require_relative "secret_info"

module Crawler
  module Main

    include Capybara::DSL

    def self.go!(steam_id)
      session, successfully_logged_in = Crawler::Login.go!(Capybara::Session.new(:poltergeist))
      if successfully_logged_in
        Crawler::Search.by_steam_id(session, steam_id)
      else
        session.save_screenshot('failed_login.png')
      end
    end

  end
end

Crawler::Main.go!("76561198015466913")

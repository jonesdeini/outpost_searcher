module Crawler
  module Search

    def self.by_steam_id(session, steam_id)
      session.visit("/find")
      sleep 4 #wait_for_javascript
      begin
        session.fill_in("steamid", :with => steam_id)
      rescue
        binding.pry # still need to figure out why this happens
      end
      session.click_on("Find!")
      sleep 4 #wait_for_javascript
      player_link = cruft_to_get_link(session)
      session.visit(player_link)
      sleep 4 #wait_for_javascript
      session.save_screenshot('screenshot.png')
      Crawler::Output.report_results(session, steam_id)
    end

    def self.cruft_to_get_link(session)
      session.html.scan(/\/user\/\d+/).last
    end
    private_class_method :cruft_to_get_link

  end
end

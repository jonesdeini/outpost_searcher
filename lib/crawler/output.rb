module Crawler
  module Output

    def self.report_results(session, steam_id)
      trader = session.has_content?("Looks like this user has never made a trade")
      puts "Steam ID: #{steam_id}", "Has ever made a trade?: #{trader}"
    end

  end
end

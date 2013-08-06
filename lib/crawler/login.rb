module Crawler
  module Login

    def self.go!(session)
      logged_in = false
      session.visit("/login")
      session.fill_in("username", :with => STEAM_USER)
      session.fill_in("password", :with => STEAM_PASS)
      session.click_on("imageLogin")
      wait_for_javascript
      unless session.has_content?("Error verifying humanity")
        session, logged_in = handle_steam_guard(session)
      end
      return session, logged_in
    end

    def self.handle_steam_guard(session)
      if session.has_content?("SteamGuard")
        auth_code = Crawler::AuthMail.get_two_step_auth_code
        session.fill_in("authcode", :with => auth_code)
        session.execute_script("SubmitAuthCode()")
        wait_for_javascript
        session.execute_script("LoginComplete()")
        wait_for_javascript
        return session, true
      else
        # not sure what happens when it doesn't hit the steamguard.
        session.save_screenshot('no_steamguard.png')
        puts session.html
        return session, false
      end
    end
    private_class_method :handle_steam_guard

    def self.wait_for_javascript
      sleep 4
    end
    private_class_method :wait_for_javascript

  end
end

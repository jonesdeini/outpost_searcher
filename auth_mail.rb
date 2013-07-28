require "gmail"
require "./main"

load "secret_info.rb"

class AuthMail

  def self.get_two_step_auth_code
    Gmail.connect(GMAIL_USER, GMAIL_PASS) do |gmail|
      gmail.inbox.emails(:unread, :from => "noreply@steampowered.com").each do |steam_email|
        steam_email.message.body.scan(/<h2>\w{5}<\/h2>/).first
      end
    end
  end

end

Main.go! nil
AuthMail.get_two_step_auth_code

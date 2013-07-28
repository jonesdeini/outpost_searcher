require "gmail"
require "./main"

load "secret_info.rb"

class AuthMail

  def self.get_two_step_auth_code
    Gmail.connect(GMAIL_USER, GMAIL_PASS) do |gmail|
      steam_emails = gmail.inbox.emails(:unread, :from => "noreply@steampowered.com")
      if steam_emails.count > 1
        #figure out which one is correct
      elsif steam_emails == 1 # everything actually worked
        steam_emails.first.message.body.scan(/<h2>\w{5}<\/h2>/).first
      else # == 0
        puts "NO STEAM EMAILS BRO" #log
      end
    end
  end

end

Main.go! nil
AuthMail.get_two_step_auth_code

require "gmail"

class AuthMail

  def self.get_two_step_auth_code
    Gmail.connect(GMAIL_USER, GMAIL_PASS) do |gmail|
      steam_emails = gmail.inbox.emails(:unread, :from => "noreply@steampowered.com")
      if steam_emails.count > 1
        # TODO figure out which one is correct
      elsif steam_emails.count == 1 # everything actually worked
        # this is bad and I feel bad
        return steam_emails.first.message.body.to_s.scan(/<h2>(\w{5})<\/h2>/).flatten.first
      else # == 0
        puts "NO STEAM EMAILS BRO" #log
      end
    end
  end

end

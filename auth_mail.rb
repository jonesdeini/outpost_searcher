require "gmail"

class AuthMail

  def self.get_two_step_auth_code
    Gmail.connect(GMAIL_USER, GMAIL_PASS) do |gmail|
      steam_emails = gmail.inbox.emails(:unread, :from => "noreply@steampowered.com")
      if steam_emails.count > 1
        return parse_auth_code steam_emails.sort_by(&:date).last
      elsif steam_emails.count == 1
        return parse_auth_code steam_emails.first
      else # == 0
        puts "NO STEAM EMAILS BRO" #log
      end
    end
  end

  def self.parse_auth_code(steam_email)
    # this is bad and I feel bad
    steam_email.message.body.to_s.scan(/<h2>(\w{5})<\/h2>/).flatten.first
  end

end

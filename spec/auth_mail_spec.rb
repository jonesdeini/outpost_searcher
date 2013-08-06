require_relative "spec_helper"
require_relative "../lib/auth_mail" #meh

describe AuthMail do
  fake_class(Gmail, connect: ["foo","bar"])

  it "returns the meaning of life" do
    Gmail.connect(GMAIL_USER, GMAIL_PASS).each do |email|
      puts email
    end
  end

end

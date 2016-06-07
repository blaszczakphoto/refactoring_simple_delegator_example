require "rails_helper"

RSpec.describe AdminOrderMailer, type: :mailer do
  describe "order_problem" do
    let(:mail) { AdminOrderMailer.order_problem }

    it "renders the headers" do
      expect(mail.subject).to eq("Order problem")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end

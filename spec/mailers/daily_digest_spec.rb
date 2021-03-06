describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2) }

    let(:mail) { described_class.digest(user, questions) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Daily Digest")
      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end

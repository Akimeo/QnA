describe QuestionUpdatesMailer, type: :mailer do
  let(:user) { create(:user) }

  describe "send_update" do
    let(:answer) { create(:answer) }
    let(:mail) { described_class.send_update(user, answer) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer for question \"#{answer.question.title}\"")
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end

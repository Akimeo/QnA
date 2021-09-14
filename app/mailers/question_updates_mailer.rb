class QuestionUpdatesMailer < ApplicationMailer
  def send_update(user, answer)
    @answer = answer

    mail to: user.email
  end
end

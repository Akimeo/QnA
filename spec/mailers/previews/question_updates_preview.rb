# Preview all emails at http://localhost:3000/rails/mailers/question_updates
class QuestionUpdatesPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/question_updates/send_update
  def send_update
    QuestionUpdatesMailer.send_update
  end

end

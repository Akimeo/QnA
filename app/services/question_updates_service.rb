class QuestionUpdatesService
  def send_update(answer)
    answer.question.subscriptions.includes(:user).each do |subscription|
      QuestionUpdatesMailer.send_update(subscription.user, answer).deliver_later
    end
  end
end

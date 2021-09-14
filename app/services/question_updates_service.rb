class QuestionUpdatesService
  def send_update(answer)
    answer.question.subscriptions.includes(:user).find_each(batch_size: 500) do |subscription|
      QuestionUpdatesMailer.send_update(subscription.user, answer).deliver_later
    end
  end
end

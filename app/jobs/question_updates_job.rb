class QuestionUpdatesJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionUpdatesService.new.send_update(answer)
  end
end

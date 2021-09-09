import consumer from './consumer'

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({
    channel: "AnswersChannel",
    question_id: $('.question-show').data('questionId')
  }, {
    received(data){
      if (data.user_id != gon.user_id) {
        $('.answers').append(data.answer)

        if (gon.user_id != null) {
          $('.new-comment:hidden').show()
          $('.vote-links:hidden').show()
        }

        if (gon.user_id == data.question_author_id) $('.actions:hidden').show()
      }
    }
  })
})

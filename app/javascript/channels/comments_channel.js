import consumer from './consumer'

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({
    channel: "CommentsChannel",
    question_id: $('.question-show').data('questionId')
  }, {
    received(data){
      if (data.user_id != gon.user_id) $(`#${data.commentable_type.toLowerCase()}-${data.commentable_id} .comments`).append(data.comment)
    }
  })
})

$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e) {
    e.preventDefault()
    const questionId = $(this).data('questionId')
    $('#question-text-' + questionId).hide()
    $('form#edit-question-' + questionId).show()
  })
})

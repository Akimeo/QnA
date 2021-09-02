$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-link', function(e) {
    e.preventDefault()
    const questionId = $(this).data('questionId')
    $(`#question-${questionId} .content`).hide()
    $(`#question-${questionId} form`).show()
    $(`#question-${questionId} input[type=submit]`).val('Save')
  })
})

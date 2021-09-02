$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-link', function(e) {
    e.preventDefault()
    const answerId = $(this).data('answerId')
    $(`#answer-${answerId} .content`).hide()
    $(`#answer-${answerId} form`).show()
    $(`#answer-${answerId} input[type=submit]`).val('Save')
  })

  const bestAnswerId = $('.best-answer:visible').data('answerId')
  $(`#answer-${bestAnswerId}`).prependTo('.answers')
})

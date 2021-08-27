$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault()
    const answerId = $(this).data('answerId')
    $('#answer-text-' + answerId).hide()
    $('form#edit-answer-' + answerId).show()
  })

  const bestAnswerId = $('.answer-best:visible').data('answerId')
  $('#answer-' + bestAnswerId).prependTo('.answers')
})
$(document).on('turbolinks:load', function(){

  const cancelVoteLink = (vote) => `<a data-type='json' class='cancel-vote-link' data-remote='true' rel='nofollow' data-method='delete' href='/votes/${vote.id}'>Cancel</a>`

  const voteLink = (name, status, vote) => `<a data-type='json' class='vote-link' data-remote='true' rel='nofollow' data-method='post' href='/votes?status=${status}&amp;votable_id=${vote.votable_id}&amp;votable_type=${vote.votable_type}' >${name}</a>`

  $('.voting').on('ajax:success', '.vote-link', function(e) {
    const rating = e.detail[0].rating
    const vote = e.detail[0].vote
    const text = vote.status === 'upvote' ? 'Upvoted!' : 'Downvoted!'

    $(this).closest('.voting').find('.rating').html(`Rating: ${rating}`)
    $(this).closest('.voting').find('.vote-links').html(text + cancelVoteLink(vote))
  })

  $('.voting').on('ajax:success', '.cancel-vote-link', function(e) {
    const rating = e.detail[0].rating
    const vote = e.detail[0].vote
    $(this).closest('.voting').find('.rating').html(`Rating: ${rating}`)
    $(this).closest('.voting').find('.vote-links').html(voteLink('Upvote', 'upvote', vote) + voteLink('Downvote', 'downvote', vote))
  })
})

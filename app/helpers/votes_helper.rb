module VotesHelper
  def vote_link(text, status, votable)
    link_to text,
            votes_path(votable_type: votable.class.to_s.underscore, votable_id: votable.id, status: status),
            method: :post,
            class: 'vote-link',
            data: { type: :json },
            remote: true
  end
end

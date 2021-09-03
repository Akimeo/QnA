describe Vote, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to :votable }

  it { should validate_presence_of :status }

  it { should define_enum_for(:status).with_values(not_yet: 0, upvote: 1, downvote: -1) }
end

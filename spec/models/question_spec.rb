describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to(:author).class_name('User') }
  it { should belong_to(:best_answer).class_name('Answer').optional }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end

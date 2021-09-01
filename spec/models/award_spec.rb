describe Award, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :title }

  it 'has one attached file' do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it { should validate_attached_of(:image) }

  it { should validate_content_type_of(:image).allowing('image/png', 'image/jpeg') }
end

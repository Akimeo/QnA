class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, User

    can :create, [Question, Answer, Comment]
    can :create_vote, [Question, Answer] do |votable|
      !user.author_of?(votable) && !votable.vote_of(user)
    end

    can :update, [Question, Answer], author_id: user.id

    can :destroy, [Question, Answer, Vote], author_id: user.id
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }

    can :choose_best_answer, Question, author_id: user.id
  end
end

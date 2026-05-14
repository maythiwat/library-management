# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :librarian
      can :manage, Author
      can :manage, Book
      can :manage, BookTag
      can :manage, Tag
      can :read, User
      can :read, MemberProfile
    else
      can :read, Author
      can :read, Book
      can :read, BookTag
      can :read, Tag
    end
  end
end

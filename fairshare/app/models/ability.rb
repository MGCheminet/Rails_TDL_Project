# frozen_string_literal: true

class Ability
  include CanCan::Ability

    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

   
    
  def initialize(user)
    user ||= Usuario.new # Guest user (not logged in)

    # Define abilities for different user roles
    if user.admin?
      can :manage, :all # Admin can manage all resources
    else
      can :read, :all # Non-admin users can read all resources

      can :create, Grupo # Allow users to create groups
      can :manage, Grupo, created_by: user.id # Allow users to manage groups they created
      can :manage, Usuario, id: user.id # Allow users to manage their own profile

      # Allow users to add other users to a group
      can :update, Grupo do |grupo|
        grupo.created_by == user.id
      end
      can :add_usuarios, Grupo do |grupo|
        grupo.created_by == user.id
      end
    end
  end
end  

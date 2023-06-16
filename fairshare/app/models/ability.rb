# frozen_string_literal: true

class Ability
  include CanCan::Ability
    
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

      can :add_usuarios, Grupo, created_by: user.id
    end
  end
end  

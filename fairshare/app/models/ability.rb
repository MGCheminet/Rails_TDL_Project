class Ability
  include CanCan::Ability
    
  def initialize(user)
    user ||= Usuario.new # Guest user (not logged in)

    if user.admin?
      can :manage, :all # Admin can manage all resources
    else
      can :read, :all # Non-admin users can read all resources

      can :create, Grupo # Allow users to create groups

      # Allow group creator to manage the group and modify the users
      can :manage, Grupo, created_by: user.id
      can :manage, Usuario, id: user.id, grupos: { created_by: user.id }

      # Allow admin to change the group creator and make modifications
      #can :manage, Grupo, created_by: user.id_admin
      #can :manage, Usuario, id: user.id_admin
    end
  end
end



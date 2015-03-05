class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    #can :manage, :all #禁用权限

    # For Admin scope
    if user.persisted?
      user.role.permissions.each do |permission|
        can permission.action.to_sym, permission.resource.camelize.safe_constantize
      end
    end

    # For Main scope
    if user.persisted?
      can [:show, :index, :create, :update], Trade, user_id: user.id
    end
    can [:show, :index], Hotel, active: true, published: true
  end
end

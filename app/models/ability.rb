class Ability
  include CanCan::Ability

  def initialize(user)
    #can :manage, :all #禁用权限
    user.role.permissions.each do |permission|
      can permission.action.to_sym, permission.resource.camelize.safe_constantize
    end
  end
end

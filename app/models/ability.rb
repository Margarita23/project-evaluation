class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
      if user.admin?
        can :manage, :all
      elsif !user.new_record?
        can :read, :all
        can :manage, Project
        can :manage, [Opportunity, Benefit, Cost, Risk]
      else
        cannot :read, :all
      end
    
  end
end

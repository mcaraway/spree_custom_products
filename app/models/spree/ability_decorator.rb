class AbilityDecorator
  include CanCan::Ability
  def initialize(user)
    #############################
    can :manage, Spree::Image
    #############################
  end

  Spree::Ability.register_ability(AbilityDecorator)
end
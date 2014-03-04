class AbilityDecorator
  include CanCan::Ability
  def initialize(user)
    #############################
    can :manage, Spree::Image
    #############################
    can :manage, Spree::CustomProduct
  end

  Spree::Ability.register_ability(AbilityDecorator)
end
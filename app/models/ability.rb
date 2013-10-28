class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.staff_role?
      can :read, HealthDataStandards::CQM::Measure #Measure
      can :read, Record
      can :manage, Provider
      can :manage, :providers
      can :manage, Team
      can :manage, User, id: user.id
      cannot :manage, User unless APP_CONFIG['allow_user_update']
    elsif user.id
      can :read, Record do |patient|
        patient.providers.map(&:npi).include?(user.npi)
      end
      can :read, HealthDataStandards::CQM::Measure #Measure
      can :read, Provider, npi: user.npi
      can :manage, Team
      can :manage, User, id: user.id
      cannot :manage, User unless APP_CONFIG['allow_user_update']
    end

  end
end

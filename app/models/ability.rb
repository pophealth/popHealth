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
    opml = APP_CONFIG['use_opml_structure']
    user ||= User.new

    if user.admin?
      can :manage, :all
      # can [:create,:delete], Record
      # can :manage, Provider
      # can [:read, :recalculate,:create, :deleted], QME::QualityReport
      # can [:create,:delete], HealthDataStandards::CQM::Measure
    elsif user.staff_role?
      can :read, HealthDataStandards::CQM::Measure
      if opml
        can :read, Record
        can :manage, Provider
        can :manage, :providers
      else
        can :read, Record do |patient|
          user.practice_id == patient.practice_id
        end
        can :manage, Provider do |prov|
          if prov.practice
            user.practice_id == prov.practice.id
          elsif prov.parent      
            user.practice_id == prov.parent.practice.id
          else
            false
          end
        end
      end
      can :manage, User, id: user.id
      cannot :manage, User unless APP_CONFIG['allow_user_update']
      can [:read, :delete, :recalculate,:create] , QME::QualityReport
      can :manage, Team do |team|
        team.user_id == user._id
      end
    elsif user.id
      can :read, Record do |patient|
        if opml
          patient.providers.map(&:npi).include?(user.npi)
        else
          patient.providers.map(&:npi).include?(user.npi) && user.practice.id == patient.practice_id
        end
      end
      can [:read,:delete, :recalculate, :create], QME::QualityReport do |qr|
         provider = Provider.by_npi(user.npi).first
         provider ? (qr.filters || {})["providers"].include?(provider.id) : false
      end
      can :read, HealthDataStandards::CQM::Measure
      can :read, Provider do |pv|
        user.npi && (pv.npi == user.npi)
      end
      can :manage, User, id: user.id
      cannot :manage, User unless APP_CONFIG['allow_user_update']
    end

  end
end

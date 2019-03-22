module Homeland::Site
  class Ability
    include CanCan::Ability

    attr_reader :user

    def initialize(u)
      @user = u
      if @user.blank?
        roles_for_anonymous
      elsif user.roles?(:site_editor)
        can :create, ::Site
      else
        roles_for_anonymous
      end
    end

    protected

    # 普通会员权限
    def roles_for_site_editors
      can :create, ::Site
      basic_read_only
    end

    # 未登录用户权限
    def roles_for_anonymous
      cannot :manage, ::Site
      basic_read_only
    end

    def basic_read_only
      can :read, ::Site
    end
  end
end

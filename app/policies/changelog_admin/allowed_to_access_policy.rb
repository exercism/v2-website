module ChangelogAdmin
  class AllowedToAccessPolicy
    def self.allowed?(*args)
      new(*args).allowed?
    end

    def initialize(user)
      @user = user
    end

    def allowed?
      user.admin? || user.may_edit_changelog?
    end

    private
    attr_reader :user
  end
end

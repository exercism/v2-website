module ChangelogAdmin
  class AllowedToPublishEntryPolicy
    def self.allowed?(*args)
      new(*args).allowed?
    end

    def initialize(user)
      @user = user
    end

    def allowed?
      user.admin?
    end

    private
    attr_reader :user
  end
end

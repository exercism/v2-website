module ChangelogAdmin
  class AllowedToDeleteEntryPolicy
    def self.allowed?(*args)
      new(*args).allowed?
    end

    def initialize(user:, entry:)
      @user = user
      @entry = entry
    end

    def allowed?
      user.admin?
    end

    private
    attr_reader :user, :entry
  end
end

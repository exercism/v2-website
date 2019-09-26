module ChangelogAdmin
  class AllowedToEditEntryPolicy
    def self.allowed?(*args)
      new(*args).allowed?
    end

    def initialize(user:, entry:)
      @user = user
      @entry = entry
    end

    def allowed?
      user_allowed? && unpublished?
    end

    private
    attr_reader :entry, :user

    def user_allowed?
      entry.created_by?(user) || user.admin?
    end

    def unpublished?
      !entry.published?
    end
  end
end

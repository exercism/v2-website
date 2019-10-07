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
      admin? || own_unpublished_entry?
    end

    private
    attr_reader :user, :entry

    def admin?
      user.admin?
    end

    def own_unpublished_entry?
      entry.created_by?(user) && !entry.published?
    end
  end
end

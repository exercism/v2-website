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
      entry.created_by?(user)
    end

    private
    attr_reader :entry, :user
  end
end

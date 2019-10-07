module ChangelogAdmin
  class ChangelogEntryAction
    def self.all
      [
        ChangelogEntryAction.new(
          name: :publish,
          confirm: true,
          method: :post,
          action: :publish,
        ),
        ChangelogEntryAction.new(
          name: :unpublish,
          confirm: true,
          method: :post,
          action: :unpublish,
          enabled: Flipper.enabled?(:changelog_destructive),
        ),
        ChangelogEntryAction.new(
          name: :edit,
          confirm: false,
          method: :get,
          action: :edit,
        ),
        ChangelogEntryAction.new(
          name: :delete,
          confirm: true,
          method: :delete,
          action: :destroy,
          enabled: Flipper.enabled?(:changelog_destructive),
        ),
      ]
    end

    def self.enabled
      all.select { |action| action.enabled? }
    end

    def initialize(name:, confirm:, method:, action: nil, enabled: true)
      @name = name
      @confirm = confirm
      @method = method
      @action = action
      @enabled = enabled
    end

    def enabled?
      enabled
    end

    def render_for(context, entry, user)
      return unless allowed?(entry, user)

      context.link_to(
        name.capitalize,
        { action: action, controller: "changelog_admin/entries", id: entry.id },
        data: { confirm: confirmation_text, method: method }
      )
    end

    private
    attr_reader :name, :confirm, :method, :action, :enabled

    def allowed?(entry, user)
      policy.allowed?(user: user, entry: entry)
    end

    def confirmation_text
      return false unless confirm

      "Are you sure you want to #{name} this entry?"
    end

    def policy
      "ChangelogAdmin::AllowedTo#{name.capitalize}EntryPolicy".constantize
    end
  end
end

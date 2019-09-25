module ChangelogEntryHelper
  def allowed_to_edit_changelog_entry?(entry, user: current_user)
    ChangelogAdmin::AllowedToEditEntryPolicy.allowed?(entry: entry, user: user)
  end
end

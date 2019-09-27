module ChangelogEntryHelper
  def allowed_to_edit_changelog_entry?(entry, user: current_user)
    ChangelogAdmin::AllowedToEditEntryPolicy.allowed?(entry: entry, user: user)
  end

  def allowed_to_publish_changelog_entry?(entry, user: current_user)
    ChangelogAdmin::AllowedToPublishEntryPolicy.allowed?(
      entry: entry,
      user: user
    )
  end
end

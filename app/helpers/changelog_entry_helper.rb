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

  def allowed_to_unpublish_changelog_entry?(entry, user: current_user)
    ChangelogAdmin::AllowedToUnpublishEntryPolicy.allowed?(
      entry: entry,
      user: user
    )
  end

  def changelog_entry_info_url_text(info_url)
    case info_url
    when /https:\/\/github.com\/.*\/.*\/pull/
      "View PR on GitHub"
    when /https:\/\/github.com\/.*\/.*\/commit/
      "View commit on GitHub"
    when /https:\/\/github.com\/.*\/.*\/issues/
      "View issue on GitHub"
    else
      "View"
    end
  end
end

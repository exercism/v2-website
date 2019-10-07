module ChangelogEntryHelper
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

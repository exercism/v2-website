class ChangelogEntryPresenter < SimpleDelegator
  def tweet_status_text
    case tweet_status
    when "queued"
      "Preparing to tweet..."
    when "published"
      "Tweet published"
    end
  end
end

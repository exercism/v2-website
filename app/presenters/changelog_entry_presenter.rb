class ChangelogEntryPresenter < SimpleDelegator
  def tweet_status_text
    case tweet_status
    when "queued"
      "Preparing to tweet..."
    when "published"
      "Tweet published"
    when "failed"
      "Tweet failed... Retrying"
    when "created"
      "Waiting for entry to be published"
    end
  end
end

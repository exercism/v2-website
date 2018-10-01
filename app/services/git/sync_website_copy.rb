class Git::SyncWebsiteCopy
  include Mandate

  def call
    Git::SyncMentors.()
  end
end

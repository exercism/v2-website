class Git::SyncsWebsiteCopy
  include Mandate

  def call
    Git::SyncsMentors.()
  end
end

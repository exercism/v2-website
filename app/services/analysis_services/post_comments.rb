module AnalysisServices
  class PostComments < CreatesDiscussionPost
    include Mandate

    def initialize(iteration, content)
      super(iteration, User.system_user, content, type: :auto_analysis)
    end

    def call
      create_discussion_post! if content.present?
    end
  end
end

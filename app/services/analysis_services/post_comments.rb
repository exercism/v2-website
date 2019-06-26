module AnalysisServices
  class PostComments < CreatesDiscussionPost
    include Mandate

    def initialize(iteration, comments_data)
      @comments_data = comments_data

      super(iteration, User.system_user, generate_content!, type: :auto_analysis)
    end

    def call
      create_discussion_post! if content.present?
    end

    private
    attr_reader :comments_data

    def generate_content!
      repo = Git::WebsiteContent.head
      comments = comments_data.map do |comment_data|
        template = repo.automated_comment_for(comment_data['comment'])
        params = (comment_data['params'] || {}).symbolize_keys

        template % params
      end

      content = comments.join("\n\n---\n\n")
    end
  end
end


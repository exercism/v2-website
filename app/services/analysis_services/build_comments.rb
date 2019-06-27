module AnalysisServices
  class BuildComments
    include Mandate

    initialize_with :comments_data

    def call
      repo = Git::WebsiteContent.head
      comments = comments_data.map do |comment_data|
        template = repo.automated_comment_for(comment_data['comment'])
        params = (comment_data['params'] || {}).symbolize_keys

        template % params
      end

      comments.join("\n\n---\n\n")
    end
  end
end



module AnalysisServices
  class BuildComment
    include Mandate

    initialize_with :comment_data

    def call
      template, params =
        if comment_data.is_a?(Hash)
          [ comment_data['comment'], (comment_data['params'] || {}).symbolize_keys ]
        else
          [comment_data, {}]
        end

        repo.automated_comment_for(template) % params
    end

    def repo
      Git::WebsiteContent.head
    end
  end
end

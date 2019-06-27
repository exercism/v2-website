require 'test_helper'

module AnalysisServices
  class PostCommentsTest < ActiveSupport::TestCase
    test "proxies correctly" do
      system_user = create :system_user
      iteration = create :iteration

      content = "first comment\n\n---\n\nsecond comment me"
      html = ParseMarkdown.(content)

      DiscussionPost.expects(:create!).with(
        iteration: iteration,
        user: system_user,
        content: content,
        html: html,
        type: :auto_analysis
      )

      PostComments.(iteration, content)
    end
  end
end

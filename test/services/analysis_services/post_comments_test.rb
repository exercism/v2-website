require 'test_helper'

module AnalysisServices
  class PostCommentsTest < ActiveSupport::TestCase
    test "proxies correctly" do
      system_user = create :user, :system
      iteration = create :iteration

      content = %q{
Our analyzer detected that these points might be helpful for you:

---

first comment

---

second comment me
      }.strip

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

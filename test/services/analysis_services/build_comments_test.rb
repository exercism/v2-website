require 'test_helper'

module AnalysisServices
  class PostCommentsTest < ActiveSupport::TestCase
    test "generates comments correctly" do
      system_user = create :system_user
      iteration = create :iteration

      templates = {"tests.first-comment" => "first comment",
                   "tests.second-comment" => "second comment %<interpolate>s"}

      website_copy = mock
      website_copy.expects(:automated_comment_for).with("tests.first-comment").returns(templates["tests.first-comment"])
      website_copy.expects(:automated_comment_for).with("tests.second-comment").returns(templates["tests.second-comment"])
      Git::WebsiteContent.expects(:head).returns(website_copy)

      comments_data = [
        {
          'comment' => "tests.first-comment"
        },
        {
          'comment' => "tests.second-comment",
          'params' => {'interpolate' => 'me'}
        }
      ]

      expected = "first comment\n\n---\n\nsecond comment me"
      assert_equal expected, BuildComments.(comments_data)
    end
  end
end


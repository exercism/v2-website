require 'test_helper'

module AnalysisServices
  class PostCommentsTest < ActiveSupport::TestCase
    test "generates comment correctly" do
      system_user = create :user, :system
      iteration = create :iteration

      templates = {"tests.comment" => "the comment"}

      website_copy = mock
      website_copy.expects(:automated_comment_for).with("tests.comment").returns(templates["tests.comment"])
      Git::WebsiteContent.stubs(head: website_copy)

      comment_data = { 'comment' => "tests.comment" }
      expected = "the comment"
      assert_equal expected, BuildComment.(comment_data)
    end
  end
end

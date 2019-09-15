require 'test_helper'

module AnalysisServices
  class PostCommentsTest < ActiveSupport::TestCase
    test "generates single comments correctly" do
      system_user = create :user, :system
      iteration = create :iteration

      templates = {"tests.first-comment" => "first comment"}

      website_copy = mock
      website_copy.expects(:automated_comment_for).with("tests.first-comment").returns(templates["tests.first-comment"])
      Git::WebsiteContent.stubs(head: website_copy)

      comments_data = [{
        'comment' => "tests.first-comment"
      }]

      expected = "Our analyzer detected that this point might be helpful for you.\n\n---\n\nfirst comment"
      assert_equal expected, BuildComments.(comments_data)
    end

    test "generates multiple comments correctly" do
      system_user = create :user, :system
      iteration = create :iteration

      templates = {"tests.first-comment" => "first comment",
                   "tests.second-comment" => "second comment %<interpolate>s"}

      website_copy = mock
      website_copy.expects(:automated_comment_for).with("tests.first-comment").returns(templates["tests.first-comment"])
      website_copy.expects(:automated_comment_for).with("tests.second-comment").returns(templates["tests.second-comment"])
      Git::WebsiteContent.stubs(head: website_copy)

      comments_data = [
        {
          'comment' => "tests.first-comment"
        },
        {
          'comment' => "tests.second-comment",
          'params' => {'interpolate' => 'me'}
        }
      ]

      expected = "Our analyzer detected that these points might be helpful for you.\n\n---\n\nfirst comment\n\n---\n\nsecond comment me"
      assert_equal expected, BuildComments.(comments_data)
    end

    test "generates different type of comments correctly" do
      system_user = create :user, :system
      iteration = create :iteration

      templates = {"tests.first-comment" => "first comment",
                   "tests.second-comment" => "second comment %<interpolate>s"}

      website_copy = mock
      website_copy.expects(:automated_comment_for).with("tests.first-comment").returns(templates["tests.first-comment"])
      website_copy.expects(:automated_comment_for).with("tests.second-comment").returns(templates["tests.second-comment"])
      Git::WebsiteContent.stubs(head: website_copy)

      comments_data = [
        "tests.first-comment",
        {
          'comment' => "tests.second-comment",
          'params' => {'interpolate' => 'me'}
        }
      ]

      expected = "Our analyzer detected that these points might be helpful for you.\n\n---\n\nfirst comment\n\n---\n\nsecond comment me"
      assert_equal expected, BuildComments.(comments_data)
    end

  end
end


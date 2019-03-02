ENV['RAILS_ENV'] ||= 'test'

require "simplecov"

SimpleCov.start "rails"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/minitest'
require 'timecop'
require 'minitest/pride'
require 'minitest/stub_const'

require "support/stub_repo_cache"

OmniAuth.config.test_mode = true

class ActionView::TestCase
  include FactoryBot::Syntax::Methods
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  include StubRepoCache
end

class ActionMailer::TestCase
  def assert_body_includes(email, string)
    assert email.html_part.body.to_s.gsub("\n", ' ').include?(string)
  end

  def assert_text_includes(email, string)
    assert email.text_part.body.to_s.include?(string)
  end

  def refute_body_includes(email, string)
    assert !email.html_part.body.to_s.gsub("\n", ' ').include?(string)
  end

  def refute_text_includes(email, string)
    assert !email.text_part.body.to_s.include?(string)
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in!(user = nil)
    @current_user = user || create(:user, accepted_terms_at: DateTime.new(2000,1,1), accepted_privacy_policy_at: DateTime.new(2000,1,1))
    @current_user.confirm
    sign_in @current_user
  end

  def assert_correct_page(page)
    assert_includes @response.body, "<div id='#{page}'>"
  end

  def repo_mock
    content = ""
    head = "SOME_HEAD_SHA"
    repo = Git::ExercismRepo.new("https://github.com/exercism/go")
    repo.stubs(:head_commit).returns(head)
    repo.stubs(:read_docs).with(head, "ABOUT.md").returns(content)
    repo
  end
end

ActionDispatch::IntegrationTest.register_encoder :js,
  param_encoder: -> params { params },
  response_parser: -> body { body }

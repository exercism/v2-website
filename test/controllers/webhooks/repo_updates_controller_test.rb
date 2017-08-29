require 'test_helper'

class Webhooks::RepoUpdatesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "create should return 200" do
    post webhooks_repo_updates_path

    assert_response 200
  end

  test "create should create a RepoUpdate record when pushed to master" do
    webhook = load_json("test/fixtures/github/push_event.json")
    webhook["ref"] = "refs/heads/master"
    webhook["repository"]["name"] = "ruby"

    post webhooks_repo_updates_path, params: webhook

    repo_update = RepoUpdate.last
    assert_equal "ruby", repo_update.slug
  end

  test "create should not create a RepoUpdate when not pushed to master" do
    webhook = load_json("test/fixtures/github/push_event.json")

    post webhooks_repo_updates_path, params: webhook

    assert_nil RepoUpdate.last
  end

  private

  def load_json(file)
    JSON.parse(File.read(file))
  end
end

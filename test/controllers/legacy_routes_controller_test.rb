require 'test_helper'

class LegacyRoutesControllerTest < ActionDispatch::IntegrationTest
  test "submission_to_solution" do
    uuid = SecureRandom.uuid
    iteration = create :iteration, legacy_uuid: uuid
    get "/submissions/#{uuid}"
    assert_redirected_to solution_path(iteration.solution)
  end

  test "submission_to_solution for bad uuid" do
    get "/submissions/#{SecureRandom.uuid}"
    assert_redirected_to root_path
  end
end

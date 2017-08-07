require_relative './test_base'

class API::SolutionsControllerTest < API::TestBase

  def setup
    @mock_exercise = stub(files: [])
    @mock_repo = stub(exercise: @mock_exercise)
    Git::ExercismRepo.stubs(new: @mock_repo)
  end

  ["foobar", "foobar.cs", "subdir/foobar.rb"].each do |filepath|
    test "get file works with #{filepath}" do
      setup_user
      solution = create :solution

      content = "qweqweqwe"
      @mock_exercise.expects(:read_file).with(filepath).returns(content)
      get "/api/v1/solutions/#{solution.uuid}/files/#{filepath}", headers: @headers, as: :json
      assert_response 200
      assert content, response.body
    end
  end

end

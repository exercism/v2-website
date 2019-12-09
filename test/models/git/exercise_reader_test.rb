require "test_helper"

module Git
  class ExerciseReaderTest < ActiveSupport::TestCase
    test "returns exercise config" do
      repo_url = "file://#{Rails.root}/test/fixtures/research-track"
      repo = Git::ExercismRepo.new(repo_url)
      sha = Git::ExercismRepo.current_head(repo_url)

      reader = Git::ExerciseReader.new(
        repo,
        "ruby-1-a",
        repo.lookup(sha),
       {}
      )

      config = reader.exercise_config
      assert_equal(
        {
          "solution_files"=>["ruby_1_a.rb"],
          "test_file"=>"ruby_1_a_test.rb",
          "test_messages"=>[
            {
              "name"=>"OneWordWithOneVowel",
              "cmd"=>"Sentence.WordWithMostVowels(\"a\")"
            }
          ]
        },
        config.data
      )
    end
  end
end

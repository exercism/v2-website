require 'test_helper'
require 'webmock/minitest'

module SubmissionServices
  class UploadToS3ForTestingTest < ActiveSupport::TestCase
    test "uploads correct files" do
      original_file_1_name = "subdir/original_file_1.rb"
      original_file_2_name = "original_file_2.rb"
      original_tests_file_name = "original_tests.rb"
      exercise_ignore_file_name = "ignore.rb"
      new_file_name = "subdir/new_file.rb"

      original_file_contents = "original_file.rb contents"
      original_file_new_contents = "original_file.rb new contents"
      original_file_2_contents = "original_file_2.rb contents"
      original_tests_file_contents = "original_tests.rb contents"
      new_file_contents = "new_file.rb contents"

      mock_exercise = stub(files: [])
      mock_exercise.expects(:files).returns([original_file_1_name, original_file_2_name, original_tests_file_name, exercise_ignore_file_name])
      mock_exercise.expects(:read_file).with(original_file_2_name).returns(original_file_2_contents)
      mock_exercise.expects(:read_file).with(original_tests_file_name).returns(original_tests_file_contents)
      mock_exercise.expects(:read_file).with(original_file_1_name).never # Overriden
      mock_exercise.expects(:read_file).with(exercise_ignore_file_name).never # Ignored

      files = {
        # Override old file
        original_file_1_name => original_file_new_contents,

        # Add new file
        new_file_name => new_file_contents,

        # Don't override tests
        original_tests_file_name => "foobar",
      }

      mock_repo = stub(exercise: mock_exercise,
                       ignore_regexp: /ignore/,
                       test_pattern: "[tT]est",
                       head: "4567")
      Git::ExercismRepo.stubs(new: mock_repo)

      track = create :track, slug: 'ruby'
      exercise = create :exercise, slug: 'two-fer', track: track
      solution = create :solution, exercise: exercise
      submission = create :submission, solution: solution

      bucket = mock
      s3_client = mock
      s3_client.expects(:put_object).with(
        body: original_file_new_contents,
        bucket: bucket,
        key: "test/testing/#{submission.uuid}/#{original_file_1_name}",
        acl: 'private'
      )

      s3_client.expects(:put_object).with(
        body: new_file_contents,
        bucket: bucket,
        key: "test/testing/#{submission.uuid}/#{new_file_name}",
        acl: 'private'
      )

      s3_client.expects(:put_object).with(
        body: original_file_2_contents,
        bucket: bucket,
        key: "test/testing/#{submission.uuid}/#{original_file_2_name}",
        acl: 'private'
      )

      s3_client.expects(:put_object).with(
        body: original_tests_file_contents,
        bucket: bucket,
        key: "test/testing/#{submission.uuid}/#{original_tests_file_name}",
        acl: 'private'
      )

      Aws::S3::Client.expects(:new).returns(s3_client)
      s = UploadToS3ForTesting.new(submission.uuid, solution, files)
      s.stubs(submissions_bucket: bucket)
      s.()
    end
  end
end

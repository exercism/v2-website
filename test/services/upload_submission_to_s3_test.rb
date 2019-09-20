require 'test_helper'
require 'webmock/minitest'

class UploadSubmissionToS3Test < ActiveSupport::TestCase
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

    mock_repo = stub(exercise: mock_exercise,
                      ignore_regexp: /ignore/,
                      test_pattern: "[tT]est",
                      head: "4567")
    Git::ExercismRepo.stubs(new: mock_repo)

    track = create :track, slug: 'ruby'
    exercise = create :exercise, slug: 'two-fer', track: track
    solution = create :solution, exercise: exercise
    submission = create :submission, solution: solution

    # Override old file
    new_file_1 = Tempfile.new("#{submission.id}")
    new_file_1 << original_file_new_contents
    new_file_1.rewind
    submission.files.attach(io: new_file_1, filename: original_file_1_name)
    new_file_1.close

    # Add new file
    new_file_2 = Tempfile.new("#{submission.id}")
    new_file_2 << new_file_contents
    new_file_2.rewind
    submission.files.attach(io: new_file_2, filename: new_file_name)
    new_file_2.close

    # Don't upload test-suites
    new_tests_file = Tempfile.new("#{submission.id}")
    new_tests_file << "foobar"
    new_tests_file.rewind
    submission.files.attach(io: new_tests_file, filename: original_tests_file_name)
    new_tests_file.close

    bucket = mock
    s3_client = mock
    s3_client.expects(:put_object).with(
      body: original_file_new_contents,
      bucket: bucket,
      key: "test/submissions/#{submission.id}/#{original_file_1_name}",
      acl: 'private'
    )

    s3_client.expects(:put_object).with(
      body: new_file_contents,
      bucket: bucket,
      key: "test/submissions/#{submission.id}/#{new_file_name}",
      acl: 'private'
    )

    s3_client.expects(:put_object).with(
      body: original_file_2_contents,
      bucket: bucket,
      key: "test/submissions/#{submission.id}/#{original_file_2_name}",
      acl: 'private'
    )

    s3_client.expects(:put_object).with(
      body: original_tests_file_contents,
      bucket: bucket,
      key: "test/submissions/#{submission.id}/#{original_tests_file_name}",
      acl: 'private'
    )

    Aws::S3::Client.expects(:new).returns(s3_client)
    s = UploadSubmissionToS3.new(submission)
    s.stubs(submissions_bucket: bucket)
    s.()
  end
end


require 'test_helper'

class CreateSubmissionTest < ActiveSupport::TestCase
  test "creates for submission user" do
    solution = create :solution
    code = "foobar"
    filename = "dog/foobar.rb"
    file_contents = "something = :else"

    files = [[filename, file_contents]]

    ProcessNewSubmissionJob.expects(:perform_later).with do |submission|
      assert submission.is_a?(Submission)
    end

    submission = CreateSubmission.(solution, files)

    assert submission.persisted?
    assert_equal submission.solution, solution
    assert_equal 1, submission.files.count

    file = submission.files.first
    assert_equal filename, file.filename.with_slashes
    assert_equal file_contents, file.download
  end

  test "works for not-duplicate files" do
    filename1 = "foobar"
    filename2 = "barfoo"
    file_contents1 = "foobar123"
    file_contents2 = "barfoo123"
    solution = create :solution
    submission = create :submission, solution: solution

    files = [[filename1, file_contents1], [filename2, file_contents2]]

    submission = CreateSubmission.(solution, files)
    assert submission.persisted?
    assert_equal 2, submission.files.count
  end

  test "raises for duplicate files" do
    skip
    filename1 = "foobar"
    filename2 = "barfoo"
    file_contents1 = "foobar123"
    file_contents2 = "barfoo123"
    solution = create :solution
    submission = create :submission, solution: solution
    create :submission_file, submission: submission, filename: filename1, file_contents: file_contents1
    create :submission_file, submission: submission, filename: filename2, file_contents: file_contents2

    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename1}\"\r\nContent-Type: application/octet-stream\r\n"
    file1 = mock(read: file_contents1, headers: headers)
    headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"#{filename2}\"\r\nContent-Type: application/octet-stream\r\n"
    file2 = mock(read: file_contents2, headers: headers)

    assert_raises do
      CreateSubmission.(solution, [file1, file2])
    end
  end
end

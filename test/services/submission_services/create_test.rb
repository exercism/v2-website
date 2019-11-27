require 'test_helper'

module SubmissionServices
  class CreateTest < ActiveSupport::TestCase
    test "creates for submission user" do
      solution = create :solution
      code = "foobar"
      filename1 = "foobar"
      filename2 = "barfoo"
      file_contents1 = "foobar123"
      file_contents2 = "barfoo123"
      uuid = SecureRandom.uuid

      files = {filename1 => file_contents1, filename2 => file_contents2}

      UploadToS3ForTesting.expects(:call).with(uuid, solution, solution.track, files)
      UploadToS3ForStorage.expects(:call).with(uuid, files)
      RunTests.expects(:call).with(uuid, solution)

      Create.(uuid, solution, files)

      submission = Submission.find_by_uuid!(uuid)
      assert_equal submission.solution, solution
      assert_equal [filename1, filename2], submission.filenames

      #file = submission.files.first
      #assert_equal filename1, file.filename.with_slashes
      #assert_equal file_contents1, file.download
    end
  end
end

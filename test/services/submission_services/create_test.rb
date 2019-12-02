require 'test_helper'

module SubmissionServices
  class CreateTest < ActiveSupport::TestCase
    test "creates for submission user" do
      uuid = SecureRandom.uuid
      mapped_uuid1 = "uuid-1"
      mapped_uuid2 = "uuid-2"

      solution = create :solution
      code = "foobar"
      filename1 = "foobar"
      filename2 = "barfoo"
      file_contents1 = "foobar123"
      file_contents2 = "barfoo123"

      files = {filename1 => file_contents1, filename2 => file_contents2}
      mapped_files = {mapped_uuid1 => file_contents1, mapped_uuid2 => file_contents2}

      SecureRandom.expects(:uuid).twice.returns(mapped_uuid1, mapped_uuid2)
      BroadcastSubmissionJob.expects(:perform_now).with do |submission|
        assert_equal Submission, submission.class 
      end

      UploadToS3ForTesting.expects(:call).with(uuid, solution, solution.track, files)
      UploadToS3ForStorage.expects(:call).with(uuid, mapped_files)
      RunTests.expects(:call).with(uuid, solution)

      Create.(uuid, solution, files)

      submission = Submission.find_by_uuid!(uuid)
      assert_equal submission.solution, solution
      assert_equal({filename1 => mapped_uuid1, filename2 => mapped_uuid2}, submission.filenames)
    end
  end
end

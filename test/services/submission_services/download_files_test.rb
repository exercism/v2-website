require 'test_helper'
require 'webmock/minitest'

module SubmissionServices
  class DownloadFilesTest < ActiveSupport::TestCase
    test "uploads correct files" do
      submission_uuid = SecureRandom.uuid

      mapped_name_1 = SecureRandom.uuid
      mapped_name_2 = SecureRandom.uuid

      file_1_name = "original_file_1.rb"
      file_2_name = "original_file_2.rb"

      file_1_contents = "file 1 contents"
      file_2_contents = "file 2 contents"

      mapped_filenames = {
        file_1_name => mapped_name_1,
        file_2_name => mapped_name_2
      }

      bucket = mock
      s3_client = mock
      resp1 = mock
      s3_client.expects(:get_object).with(
        bucket: bucket,
        key: "test/storage/#{submission_uuid}/#{mapped_name_1}",
      ).returns(resp1)
      resp1.expects(:body).returns(mock(read: file_1_contents))

      resp2 = mock
      s3_client.expects(:get_object).with(
        bucket: bucket,
        key: "test/storage/#{submission_uuid}/#{mapped_name_2}",
      ).returns(resp2)
      resp2.expects(:body).returns(mock(read: file_2_contents))

      Aws::S3::Client.expects(:new).returns(s3_client)
      s = DownloadFiles.new(submission_uuid, mapped_filenames)
      s.stubs(submissions_bucket: bucket)

      expected = {file_1_name => file_1_contents, file_2_name => file_2_contents}
      assert_equal expected, s.()
    end
  end
end

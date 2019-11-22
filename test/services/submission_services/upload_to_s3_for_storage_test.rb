require 'test_helper'
require 'webmock/minitest'

module SubmissionServices
  class UploadToS3ForStorageTest < ActiveSupport::TestCase
    test "uploads correct files" do
      file_1_name = "subdir/original_file_1.rb"
      file_2_name = "original_file_2.rb"
      file_3_name = "original_file_3.rb"

      file_1_contents = "file 1 contents"
      file_2_contents = "file 2 contents"
      file_3_contents = "file 3 contents"

      files = {
        file_1_name => file_1_contents,
        file_2_name => file_2_contents,
        file_3_name => file_3_contents,
      }

      submission = create :submission

      bucket = mock
      s3_client = mock
      s3_client.expects(:put_object).with(
        body: file_1_contents,
        bucket: bucket,
        key: "test/storage/#{submission.uuid}/#{file_1_name}",
        acl: 'private'
      )

      s3_client.expects(:put_object).with(
        body: file_2_contents,
        bucket: bucket,
        key: "test/storage/#{submission.uuid}/#{file_2_name}",
        acl: 'private'
      )

      s3_client.expects(:put_object).with(
        body: file_3_contents,
        bucket: bucket,
        key: "test/storage/#{submission.uuid}/#{file_3_name}",
        acl: 'private'
      )

      Aws::S3::Client.expects(:new).returns(s3_client)
      s = UploadToS3ForStorage.new(submission.uuid, files)
      s.stubs(submissions_bucket: bucket)
      s.()
    end
  end
end

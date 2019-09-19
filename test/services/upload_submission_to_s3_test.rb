require 'test_helper'
require 'webmock/minitest'

class UploadSubmissionToS3Test < ActiveSupport::TestCase
  test "uploads files" do
    submission = create :submission

    file1 = Tempfile.new("#{submission.id}")
    file1 << "file 1 code"
    file1.rewind
    submission.files.attach(io: file1, filename: "dir/file1.rb")
    file1.close

    file2 = Tempfile.new("#{submission.id}")
    file2 << "file 2 code"
    file2.rewind
    submission.files.attach(io: file2, filename: "file2.rb")
    file2.close

    bucket = mock
    s3_client = mock
    s3_client.expects(:put_object).with(
      body: "file 1 code",
      bucket: bucket,
      key: "test/submissions/#{submission.id}/dir/file1.rb",
      acl: 'private'
    )

    s3_client.expects(:put_object).with(
      body: "file 2 code",
      bucket: bucket,
      key: "test/submissions/#{submission.id}/file2.rb",
      acl: 'private'
    )

    Aws::S3::Client.expects(:new).returns(s3_client)
    s = UploadSubmissionToS3.new(submission)
    s.stubs(submissions_bucket: bucket)
    s.()
  end
end


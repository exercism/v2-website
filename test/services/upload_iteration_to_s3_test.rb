require 'test_helper'
require 'webmock/minitest'

class UploadIterationToS3Test < ActiveSupport::TestCase
  test "uploads files" do
    iteration = create :iteration
    file_1 = create :iteration_file, iteration: iteration
    file_2 = create :iteration_file, iteration: iteration

    bucket = mock
    s3_client = mock
    s3_client.expects(:put_object).with(
      body: file_1.file_contents,
      bucket: bucket,
      key: "test/iterations/#{iteration.id}/#{file_1.filename}",
      acl: 'private'
    )

    s3_client.expects(:put_object).with(
      body: file_2.file_contents,
      bucket: bucket,
      key: "test/iterations/#{iteration.id}/#{file_2.filename}",
      acl: 'private'
    )

    Aws::S3::Client.expects(:new).returns(s3_client)
    s = UploadIterationToS3.new(iteration)
    s.stubs(iterations_bucket: bucket)
    s.()
  end
end

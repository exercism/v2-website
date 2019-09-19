class UploadSubmissionToS3
  include Mandate

  initialize_with :submission

  def call
    path = "#{Rails.env}/submissions/#{submission.id}"
    submission.files.each do |file|
      key = "#{path}/#{file.filename.with_slashes}"
      s3_client.put_object(body: file.download,
                           bucket: submissions_bucket,
                           key: key,
                           acl: 'private')
    end
  end


  def s3_client
    @client ||= Aws::S3::Client.new(
      access_key_id: Rails.application.secrets.aws_access_key_id,
      secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: Rails.application.secrets.aws_region
    )
  end

  def submissions_bucket
    Rails.application.secrets.aws_submissions_bucket
  end
end

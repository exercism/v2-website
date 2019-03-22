class UploadIterationToS3
  include Mandate

  initialize_with :iteration

  def call
    path = "iterations/#{iteration.id}"
    iteration.files.each do |file|
      key = "#{path}/#{file.filename}"
      s3_client.put_object(body: file.file_contents,
                           bucket: iterations_bucket,
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

  def iterations_bucket
    Rails.application.secrets.aws_iterations_bucket
  end
end

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
    # CCARE - We need the config reading/setting here.
    @s3_client ||= Aws::S3::Client.new
  end

  def iterations_bucket
    # CCARE - We need the config reading/setting here.
    ""
  end
end

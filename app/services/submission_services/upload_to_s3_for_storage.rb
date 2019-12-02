# t = Time.now.to_f; UploadSubmissionToS3ForStorage.(submission, files); Time.now.to_f - t
module SubmissionServices
  class UploadToS3ForStorage
    include Mandate

    def initialize(submission_uuid, files)
      @files = files
      @path = "#{Rails.env}/storage/#{submission_uuid}"
      @files_to_upload = {}
    end

    def call
      threads = []
      files.each do |filename, code|
        threads << Thread.new { upload_file(filename, code) }
      end
      threads.each(&:join)
    end

    private
    attr_reader :files, :path

    def upload_file(filename, code)
      s3_client.put_object(body: code,
                           bucket: submissions_bucket,
                           key: "#{path}/#{filename}",
                           acl: 'private')
    end

    memoize
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
end

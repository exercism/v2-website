module SubmissionServices
  class DownloadFiles
    include Mandate
    def initialize(submission_uuid, filenames)
      @filenames = filenames
      @files = Concurrent::Map.new
      @path = "#{Rails.env}/storage/#{submission_uuid}"
    end

    def call
      threads = []
      filenames.each do |original_filename, stored_filename|
        threads << Thread.new { download_file(original_filename, stored_filename) }
      end
      threads.each(&:join)

      # Convert to a normal hash for the return.
      # There's probably a nicer way to do this but
      # RubyDoc is down for me so :shrug:
      files.keys.zip(files.values).to_h
    end

    private
    attr_reader :filenames, :files, :path

    def download_file(original_filename, stored_filename)
      resp = s3_client.get_object(bucket: submissions_bucket,
                                  key: "#{path}/#{stored_filename}")
      files[original_filename] = resp.body.read
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

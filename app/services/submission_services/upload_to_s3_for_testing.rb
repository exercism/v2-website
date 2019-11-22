# t = Time.now.to_f; UploadSubmissionToS3.(SecureRandom.uuid, solution, files); Time.now.to_f - t
module SubmissionServices
  class UploadToS3ForTesting
    include Mandate

    def initialize(submission_uuid, solution, input_files)
      @solution = solution
      @input_files = input_files
      @path = "#{Rails.env}/testing/#{submission_uuid}"
      @track = solution.exercise.track
      @files_to_upload = {}
    end

    def call
      # Determine the files to upload
      add_submission_files
      add_exercise_files

      # Then upload them all in parallel
      upload_files
    end

    private
    attr_reader :solution, :input_files, :path, :track, :files_to_upload

    def add_submission_files
      input_files.each do |filename, code|
        next if filename =~ Regexp.new(track.repo.test_pattern)
        next if files_to_upload[filename]
        files_to_upload[filename] = code
      end
    end

    def add_exercise_files
      exercise_slug = solution.git_slug
      track_url = track.repo_url

      exercise_reader = Git::ExercismRepo.new(track_url).exercise(exercise_slug, solution.git_sha)
      exercise_reader.files.each do |filepath|
        next if filepath =~ track.repo.ignore_regexp
        next if files_to_upload[filepath]
        files_to_upload[filepath] = exercise_reader.read_file(filepath)
      end
    end

    def upload_files
      files_to_upload.map { |filename, code|
        Thread.new do
          s3_client.put_object(body: code,
                               bucket: submissions_bucket,
                               key: "#{path}/#{filename}",
                               acl: 'private')
        end
      }.each(&:join)
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
end

class UploadSubmissionToS3
  include Mandate

  def initialize(submission)
    @submission = submission
    @path = "#{Rails.env}/submissions/#{submission.id}"
    @solution = submission.solution
    @track = solution.exercise.track
    @uploaded_files = []
  end

  def call
    upload_submission_files
    upload_exercise_files
  end

  private
  attr_reader :path, :solution, :submission, :track, :uploaded_files

  def upload_submission_files
    submission.files.each do |file|
      next if file.filename.with_slashes =~ Regexp.new(track.repo.test_pattern)
      next if uploaded_files.include?(file.filename.with_slashes)

      key = "#{path}/#{file.filename.with_slashes}"
      s3_client.put_object(body: file.download,
                           bucket: submissions_bucket,
                           key: key,
                           acl: 'private')

      uploaded_files << file.filename.with_slashes
    end
  end

  def upload_exercise_files
    exercise_slug = solution.git_slug
    track_url = track.repo_url

    exercise_reader = Git::ExercismRepo.new(track_url).exercise(exercise_slug, solution.git_sha)
    exercise_reader.files.each do |filepath|
      next if filepath =~ track.repo.ignore_regexp
      next if uploaded_files.include?(filepath)

      key = "#{path}/#{filepath}"
      body = exercise_reader.read_file(filepath)

      s3_client.put_object(body: body,
                           bucket: submissions_bucket,
                           key: key,
                           acl: 'private')

      uploaded_files << filepath
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

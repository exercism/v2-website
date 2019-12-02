module SubmissionServices
  class DuplicateSubmissionError < RuntimeError
  end

  # Creting a submission involves three stages:
  # 1. Upload the files for testing
  # 2. Upload the files for storage, with filenames as uuids for safety
  # 3. Save the submission in the database
  #
  # All three stages happen in parallel with (3) on the main thread
  # and the two upload tasks on their own threads.
  class Create
    include Mandate

    def initialize(uuid, solution, files)
      @uuid = uuid
      @solution = solution
      @track = solution.track

      @files = files
      @filename_mapping = files.each_with_object({}) do |(filename, _), h|
        h[filename] = SecureRandom.uuid
      end
    end

    def call
      # TODO
      # Check max file size for each file (small!)

      # Kick the uploading tasks off
      threads = []
      threads << Thread.new { upload_for_test_running }
      threads << Thread.new { upload_for_storage }

      # Make sure this happens on the main thread else
      # we get issues with the connection pooling
      write_to_db

      # Finally wait for everyting to finish before
      # we return
      threads.each(&:join)
    end

    private
    attr_reader :uuid, :solution, :track, :files, :filename_mapping

    # This method must NOT access the database
    def upload_for_test_running
      UploadToS3ForTesting.(uuid, solution, track, files)
      RunTests.(uuid, solution)
    end

    # This method must NOT access the database
    def upload_for_storage
      mapped_files = files.each_with_object({}) do |(filename, code), h|
        h[filename_mapping[filename]] = code
      end
      UploadToS3ForStorage.(uuid, mapped_files)
    end

    def write_to_db
      submission = Submission.create!(
        uuid: uuid,
        solution: solution,
        filenames: filename_mapping
      )

      submission.broadcast!
    end
  end
end

module SubmissionServices
  class DuplicateSubmissionError < RuntimeError
  end

  class Create
    include Mandate

    initialize_with :uuid, :solution, :files

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

    def upload_for_test_running
      UploadToS3ForTesting.(uuid, solution, files)
      RunTests.(uuid, solution)
    end

    def upload_for_storage
      UploadToS3ForStorage.(uuid, files)
    end

    def write_to_db
      Submission.create!(
        uuid: uuid,
        solution: solution,
        filenames: files.keys
      )
    end
  end
end

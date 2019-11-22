module SubmissionServices
  class DuplicateSubmissionError < RuntimeError
  end

  class Create
    include Mandate

    initialize_with :uuid, :solution, :files

    def call
      # TODO
      # Check max file size for each file (small!)

      %i{
        upload_for_test_running
        upload_for_storage
        write_to_db
      }.map { |cmd| Thread.new { send cmd } }.each(&:join)
    end

    def upload_for_test_running
      UploadToS3ForTesting.(uuid, solution, files)
      RunTests.(uuid, solution)
    end

    def upload_for_storage
      UploadToS3ForStorage.(uuid, files)
    end

    def write_to_db
      submission = Submission.create!(
        uuid: uuid,
        solution: solution,
        filenames: files.keys
      )
    end
  end
end

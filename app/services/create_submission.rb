class DuplicateSubmissionError < RuntimeError
end

class CreateSubmission
  include Mandate
  include UserHelper

  initialize_with :solution, :files

  def call
    #check_not_duplicate!

    submission = Submission.create!( solution: solution )

    files.each do |filename, code|
      tmpfile = Tempfile.new("#{solution.id}")
      tmpfile << code
      tmpfile.rewind
      submission.files.attach(
        io: tmpfile,
        filename: filename
      )
      tmpfile.close
    end

    ProcessNewSubmissionJob.perform_later(submission)

    submission
  end

  private
  attr_reader :submission

=begin
  def check_not_duplicate!
    last_submission = solution.submissions.last
    return unless last_submission

    prev_files = last_submission.files.map {|f| "#{f.filename}|#{f.file_contents_digest}" }.sort
    new_files = parsed_files.map {|f| "#{f[:filename]}|#{f[:file_contents_digest]}" }.sort
    raise DuplicateSubmissionError.new if prev_files == new_files
  end
=end
end

class DuplicateIterationError < RuntimeError
end

class CreateIteration
  include Mandate
  include UserHelper

  initialize_with :solution, :files

  def call
    check_not_duplicate!

    @iteration = Iteration.create!( solution: solution )
    parsed_files.each do |file|
      iteration.files.create!(
        filename: file[:filename],
        file_contents: file[:file_contents]
      )
    end
    if solution.team_solution?
      update_team_solution
    else
      update_solution
    end

    iteration
  end

  private
  attr_reader :iteration

  def update_solution
    solution.update(last_updated_by_user_at: Time.current)

    if !solution.mentoring_requested? &&
       solution.track_in_mentored_mode? &&
       solution.exercise.core?
      solution.update(mentoring_requested_at: Time.current)
    end

    if solution.exercise.auto_approve?
      solution.update(approved_by: user)
      CreateNotification.(
        solution.user,
        :exercise_auto_approved,
        "Your solution to <strong>#{solution.exercise.title}</strong> on the "\
        "<strong>#{solution.exercise.track.title}</strong> track has been "\
        "auto approved.",
        Rails.application.routes.url_helpers.my_solution_url(solution),
        about: solution
      )
    else
      solution.mentorships.update_all(requires_action: true) unless solution.approved?
      notify_mentors
    end

    unlock_side_exercise!
  end

  def update_team_solution
    solution.update(
      needs_feedback: true,
      has_unseen_feedback: false,
      num_iterations: solution.iterations.count
    )
  end

  private

  def unlock_side_exercise!
    return if solution.exercise.unlocks.count < 2
    side_exercise_to_unlock = solution.exercise.unlocks.first

    return if user.solutions.where(exercise_id: side_exercise_to_unlock.id).exists?

    CreateSolution.(user, side_exercise_to_unlock)
  end

  def notify_mentors
    solution.active_mentors.each do |mentor|
      CreateNotification.(
        mentor,
        :new_iteration_for_mentor,
        "<strong>#{display_handle(solution.user, solution.user_track)}</strong> has posted a new iteration on a solution you are mentoring",
        routes.mentor_solution_url(solution),
        trigger: iteration,

        # Note: This is deliberately the solution not the iteration
        # to allow for clearing without a mentor having to
        # go into every single iteration
        about: solution
      )
      DeliverEmail.(
        mentor,
        :new_iteration_for_mentor,
        iteration
      )
    end
  end

  def parsed_files
    @parsed_files ||= begin
      files.map do |file|
        filename = file.headers.split("\r\n").
                        detect{|s|s.start_with?("Content-Disposition: ")}.
                        split(";").
                        map(&:strip).
                        detect{|s|s.start_with?('filename=')}.
                        split("=").last.
                        gsub('"', '').gsub(/^\//, '')

        file_contents = file.read
        {
          filename: filename,
          file_contents: file_contents,
          file_contents_digest: IterationFile.generate_digest(file_contents)
        }
      end
    end
  end

  def check_not_duplicate!
    last_iteration = solution.iterations.last
    return unless last_iteration

    prev_files = last_iteration.files.map {|f| "#{f.filename}|#{f.file_contents_digest}" }.sort
    new_files = parsed_files.map {|f| "#{f[:filename]}|#{f[:file_contents_digest]}" }.sort
    raise DuplicateIterationError.new if prev_files == new_files
  end

  def routes
    @routes ||= Rails.application.routes.url_helpers
  end

  def user
    solution.user
  end
end

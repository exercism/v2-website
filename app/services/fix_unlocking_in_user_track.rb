# This is the canconical class for fixing unlocking
# in any user track. It should be safe to run.
# It is called when switching into mentored mode and
# might also be sporadically used to clean up tracks
# after significant structure changes.

class FixUnlockingInUserTrack
  include Mandate

  attr_reader :user_track, :user, :track
  def initialize(user_track)
    @user_track = user_track
    @user = user_track.user
    @track = user_track.track
  end

  def call
    user_track.independent_mode?? process_independent : process_mentored
  end

  # We want to just have one solution submitted for mentoring at this point
  def process_independent
    requested = user_track.solutions.not_approved.
                                     not_completed.
                                     where.not(mentoring_requested_at: nil).
                                     order("num_mentors DESC").
                                     to_a

    max = UserTrack::MAX_INDEPENDENT_MODE_MENTORING_SLOTS

    if requested.size > max
      requested[max..-1].each{|s|s.update(mentoring_requested_at: nil)}
    end
  end

  def process_mentored
    # Build a list of the solutions we're keeping.
    keep_solution_ids = []

    # Get the core exercises and unlock their dependants
    completed_core_exercise_ids = Exercise.core.where(id: user_track.solutions.completed.map(&:exercise_id)).pluck(:id)

    # Get any existing solutions that are unlocked by completed core ids
    existing_solution_ids, existing_exercise_ids = Solution.where(user_id: user.id).
                                                            joins(:exercise).
                                                            where("exercises.unlocked_by_id": completed_core_exercise_ids).
                                                            pluck(:id, :exercise_id).
                                                            transpose
    # Add the existing solutions
    keep_solution_ids += existing_solution_ids if existing_solution_ids

    # Make any new ones
    keep_solution_ids += Exercise.where(unlocked_by_id: completed_core_exercise_ids).
                                  where.not(id: existing_exercise_ids.to_a).
                                  map { |e|CreateSolution.(user, e).id }

    # Check all the bonus exercises are avaliable but don't unlock them.
    keep_solution_ids += user_track.solutions.
                                    where(exercise_id:
                                            track.exercises.
                                            side.where(unlocked_by_id: nil)
                                         ).
                                    pluck(:id)

    next_submitted_core_solutions = user_track.solutions.
                                    where(exercise_id: track.exercises.core).
                                    submitted.
                                    not_completed

    if next_submitted_core_solutions.length > 0
      next_submitted_core_solutions.each do |solution|
        solution.update(mentoring_requested_at: Time.now) unless solution.mentoring_requested?
        keep_solution_ids << solution.id
      end
    else
      # Make sure there is one unlocked core
      next_core_exercise = track.exercises.core.
                                           not_completed_for(user).
                                           order(:position).
                                           first

      # We can just use UnlockCoreExercise here, but it's more efficent to do the extra lookup
      if next_core_exercise
        next_core_solution = Solution.where(user: user, exercise: next_core_exercise).first
        keep_solution_ids << (next_core_solution.try(:id) || UnlockCoreExercise.(user, next_core_exercise).try(:id))
      end
    end

    # Delete all unsubmitted exercises that we haven't just
    # agreed to unlocked
    user_track.solutions.not_started.where.not(id: keep_solution_ids).destroy_all

    # Reset mentoring_requested_at from all solutions that haven't had
    # iterations set. I don't think we need this as a normal process but
    # if we decide we do, we can uncomment this.
    #user_track.solutions.
    #  not_submitted
    #  where.not(mentoring_requested_at: nil).
    #  update_all(mentoring_requested_at: nil)
  end
end

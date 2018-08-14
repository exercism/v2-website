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
    # Build a list of the solutions we're keeping.
    keep_solution_ids = []

    # Get the core exercises and unlock their dependants
    exercise_ids = Exercise.core.where(id: user_track.solutions.completed.map(&:exercise_id)).pluck(:id)
    keep_solution_ids += Exercise.where(unlocked_by: exercise_ids).map { |e|CreateSolution.(user, e).id }

    # Check all the bonus exercises are avalaible but don't unlock them.
    keep_solution_ids += user_track.solutions.where(exercise_id: track.exercises.side.where(unlocked_by: nil)).pluck(:id)

    # Make sure there is one unlocked core
    next_exercise = track.exercises.core.
                                    not_completed_for(user).
                                    order(:position).
                                    first
    keep_solution_ids << UnlockCoreExercise.(user, next_exercise).try(:id) if next_exercise

    # Delete all unsubmitted exercises that we haven't just
    # agreed to unlocked
    user_track.solutions.not_started.where.not(id: keep_solution_ids).destroy_all
  end
end

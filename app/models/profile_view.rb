class ProfileView
  attr_reader :profile, :track_id

  def initialize(profile, track_id: nil)
    @profile = profile
    @track_id = track_id
  end

  def helped_count
    user.
      solution_mentorships.
      joins(:solution).
      select('solutions.user_id').
      distinct.
      count
  end

  def solutions
    return @solutions if @solutions

    @solutions = profile.solutions.includes(exercise: :track)

    if track_id
      @solutions = @solutions.
        joins(:exercise).
        where("exercises.track_id": track_id)
    end

    @solutions
  end

  def tracks_for_select
    track_ids = Exercise.
      where(id: solutions.map(&:exercise_id)).
      distinct.
      pluck(:track_id)

    Track.where(id: track_ids).
      map{|l|[l.title, l.id]}.
      unshift(["Any", 0])
  end

  def reaction_counts
    Reaction.where(solution_id: solutions).group(:solution_id, :emotion).count
  end

  def comment_counts
    Reaction.
      where(solution_id: solutions).
      with_comments.
      group(:solution_id).
      count
  end

  private
  delegate :user, to: :profile
end

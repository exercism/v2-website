class SelectsSuggestedSolutionsForMentor
  def self.select(*args)
    new(*args).select
  end

  attr_reader :user, :page
  def initialize(user, page = nil)
    @user = user
    @page = page
  end

  def select
    @suggested_solutions = Solution.

      # Only mentored tracks
      joins(:exercise).
      where("exercises.track_id": tracks).

      # Not things you already mentor
      where.not(id: user.mentored_solutions).

      # Not things you've ignored
      where.not(id: user.ignored_solutions).

      # Not your own solutions
      where.not(user_id: user.id).

      # Where the person has posted at least one iteration
      where("EXISTS(SELECT NULL FROM iterations WHERE solution_id = solutions.id)").

      # Where there < 3 mentors
      where("num_mentors < 3").

      # Not approved
      where(approved_by: nil).

      # Not completed
      where(completed_at: nil).

      # Order by number of mentors (least first),
      # then age (oldest first)
      order("num_mentors ASC, last_updated_by_user_at ASC").

      includes(iterations: [], exercise: {track: []}, user: [:profile]).

      limit(20)
  end

  def tracks
    @tracks ||= user.mentored_tracks
  end
end

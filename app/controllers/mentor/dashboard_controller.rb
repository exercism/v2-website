class Mentor::DashboardController < MentorController
  def show
    @filter = params[:filter].try(:to_sym)
    @your_solutions = RetrieveSolutionsForMentor.retrieve(current_user, @filter)
    set_suggested_solutions
  end

  private

  def set_suggested_solutions
    tracks = current_user.mentored_tracks
    @suggested_solutions = Solution.
      joins(:exercise).
      where("exercises.track_id": tracks).
      where.not(id: current_user.mentored_solutions)
  end
end


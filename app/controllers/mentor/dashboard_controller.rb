class Mentor::DashboardController < MentorController

  # TODO - Remove n+1s
  def show
    @filter = params[:filter].try(:to_sym)
    @your_solutions = RetrieveSolutionsForMentor.retrieve(current_user, @filter)
    @suggested_solutions = SelectsSuggestedSolutionsForMentor.select(current_user, params[:page])

    user_ids = @your_solutions.pluck(:user_id) + @suggested_solutions.pluck(:user_id)
    @user_tracks = UserTrack.where(user_id: user_ids).
                             each_with_object({}) { |ut, h| h["#{ut.user_id}|#{ut.track_id}"] = ut }
  end
end


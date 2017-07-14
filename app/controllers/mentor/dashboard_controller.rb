class Mentor::DashboardController < MentorController
  def show
    @filter = params[:filter].try(:to_sym)
    @your_solutions = RetrieveSolutionsForMentor.retrieve(current_user, @filter)
    @suggested_solutions = SelectsSuggestedSolutionsForMentor.select(current_user, params[:page])
  end
end


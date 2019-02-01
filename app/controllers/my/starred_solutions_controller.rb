class My::StarredSolutionsController < MyController
  def index
    @solutions = Solution.published.
                          joins(:stars).
                          where("solution_stars.user_id": current_user).
                          includes({exercise: :track}).
                          distinct.
                          page(params[:page]).per(18)

    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }
  end

  def create
    @solution = Solution.published.find_by_uuid!(params[:solution_id])
    CreateSolutionStar.(current_user, @solution)
  end
end

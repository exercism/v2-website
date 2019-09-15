class SolutionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:exercise_id])
    @solutions = @exercise.solutions.
                           published.
                           includes(user: [:profile, { avatar_attachment: :blob }])

    if user_signed_in?
      @solutions = @solutions.where.not(user_id: current_user.id)
      @current_user_track = UserTrack.where(user: current_user, track: @track).first
      @user_solution = current_user.solutions.
                                    where(exercise_id: @exercise.id).
                                    where("EXISTS(select id from iterations where solution_id = solutions.id)").
                                    first
    end

    @order = params[:order]
    sql_order = case @order
                when "num_stars"; "num_stars DESC"
                when "num_comments"; "num_comments DESC"
                when "published_at_asc"; "published_at ASC"
                else;"published_at DESC"
                end

    @solutions = @solutions.reorder(sql_order)
    @total_solutions = @solutions.count
    @solutions = @solutions.page(params[:page]).per(21)
    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }
  end

  def show
    begin
      @solution = Solution.find_by_uuid!(params[:id])
    rescue
      return render action: "not_found", status: :not_found
    end

    @exercise = @solution.exercise
    @track = @exercise.track

    # If it's not published, either go to "my" page or render not_published
    unless @solution.published?
      if @solution.user == current_user
        return redirect_to [:my, @solution]
      else
        return render action: "not_published", status: :not_found
      end
    end

    # Redirect to the correct url for Google
    return redirect_to [@track, @exercise, @solution], :status => :moved_permanently if request.path != track_exercise_solution_path(@track, @exercise, @solution)

    ClearNotifications.(current_user, @solution)
    @iteration = @solution.iterations.last
    @comments = @solution.comments.
                          order('created_at ASC').
                          includes(user: [:profile, { avatar_attachment: :blob }])
  end
end

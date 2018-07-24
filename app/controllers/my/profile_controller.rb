class My::ProfileController < MyController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_profile_exists!, only: [:new, :create]
  before_action :redirect_unless_profile_exists!, only: [:show, :edit, :update, :destroy]

  def show
    redirect_to @profile
  end

  def new
    redirect_to profile_path if current_user.profile
    @profile = Profile.new(
      user: current_user,
      display_name: current_user.name.present?? current_user.name : current_user.handle
    )
  end

  def create
    @profile = if current_user.profile
        current_user.profile
      else
        CreatesProfile.create(current_user, params[:profile][:display_name])
      end

    User.find(current_user.id).update(user_params)

    if @profile.persisted?
      redirect_to action: :show
    else
      render action: :new
    end
  end

  def edit
    @user = current_user

    respond_to do |format|
      format.js { render_modal("edit-profile", "_edit_modal") }
      format.html { setup_solutions }
    end
  end

  def update
    @user = current_user

    ActiveRecord::Base.transaction do
      if @profile.update(profile_params) && @user.update(user_params)
        redirect_to @profile
      else
        setup_solutions
        render :edit
      end
    end
  end

  private

  def setup_solutions
    @helped_count = @user.solution_mentorships.joins(:solution).select('solutions.user_id').distinct.count

    @solutions = @profile.solutions.includes(exercise: :track)

    track_ids = Exercise.where(id: @solutions.map(&:exercise_id)).distinct.pluck(:track_id)
    @tracks_for_select = Track.where(id: track_ids).
      map{|l|[l.title, l.id]}.
      unshift(["Any", 0])
    @track = Track.find_by_id(params[:track_id]) if params[:track_id].to_i > 0

    @solutions = @solutions.joins(:exercise).where("exercises.track_id": @track.id) if @track
    @reaction_counts = Reaction.where(solution_id: @solutions).group(:solution_id, :emotion).count
    @comment_counts = Reaction.where(solution_id: @solutions).with_comments.group(:solution_id).count
  end

  def profile_params
    params.require(:profile).permit(
      :display_name, :bio,
      :website, :twitter, :github, :linkedin, :medium
    )
  end

  def user_params
    params.require(:user).permit(:bio, :avatar)
  end

  def set_profile
    @profile = current_user.profile
  end

  def redirect_if_profile_exists!
    profile = current_user.profile
    redirect_to profile_path(profile) if profile
  end

  def redirect_unless_profile_exists!
    redirect_to new_my_profile_path unless @profile
  end
end

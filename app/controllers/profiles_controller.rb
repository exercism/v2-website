class ProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to action: :index
  end

  before_action :set_profile, except: [:index]

  def show
    @helped_count = current_user.solution_mentorships.joins(:solution).select('solutions.user_id').distinct.count

    setup_solutions
  end

  def index
    @profiles = Profile.page(params[:page]).per(20)
  end

  def solutions
    setup_solutions
  end

  private

  def set_profile
    @user = User.find_by_handle!(params[:id])
    @profile = @user.profile
  end

  def setup_solutions
    @solutions = @profile.user.solutions.published.includes(exercise: :track)

    @tracks_for_select = Track.where(id: @solutions.joins(:exercise).select(:track_id)).
      map{|l|[l.title, l.id]}.
      unshift(["Any", 0])
    @track = Track.find_by_id(params[:track_id]) if params[:track_id].to_i > 0

    @solutions = @solutions.joins(:exercise).where("exercises.track_id": @track.id) if @track
    @reaction_counts = Reaction.where(solution_id: @solutions).group(:solution_id, :emotion).count
    @comment_counts = Reaction.where(solution_id: @solutions).with_comments.group(:solution_id).count
  end
end

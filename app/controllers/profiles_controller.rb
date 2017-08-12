class ProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to action: :index
  end

  def show
    @user = User.find_by_handle!(params[:id])
    @profile = @user.profile
    @helped_count = current_user.solution_mentorships.joins(:solution).select('solutions.user_id').distinct.count
    @solutions = @profile.user.solutions.published.includes(exercise: :track)
    @solutions = @solutions.where(track_id: track.id) if @track
    @tracks = Track.where(id: @solutions.joins(:exercise).select(:track_id))
    @track = Track.find_by_id(params[:track_id])
    @reaction_counts = Reaction.where(solution_id: @solutions).group(:solution_id, :emotion).count
    @comment_counts = Reaction.where(solution_id: @solutions).with_comments.group(:solution_id).count
  end

  def index
    @profiles = Profile.page(params[:page]).per(20)
  end

end

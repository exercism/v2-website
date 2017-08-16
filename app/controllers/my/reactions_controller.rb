class My::ReactionsController < MyController
  def index
    @solutions = current_user.reactions.includes(solution: {exercise: :track}).page(params[:page]).per(18).map(&:solution)
    @reaction_counts = Reaction.where(solution_id: @solutions.map(&:id)).group(:solution_id, :emotion).count
    @comment_counts = Reaction.where(solution_id: @solutions.map(&:id)).with_comments.group(:solution_id).count
    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }
  end

  def create
    @solution = Solution.published.find_by_uuid!(params[:solution_id])
    data = { emotion: params[:emotion] }
    @reaction = Reaction.find_or_create_by(user: current_user, solution: @solution) do |ur|
      ur.attributes = data
    end
    @reaction.update(data)
    @comments = @solution.reactions.with_comments.includes(user: :profile)
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
  end
end


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
    @reaction = Reaction.where(user: current_user, solution: @solution).first
    if @reaction
      if params[:emotion] == @reaction.emotion
        @reaction.destroy unless @reaction.comment.present?
      else
        @reaction.update(emotion: params[:emotion])
      end
    else
      @reaction = Reaction.create(user: current_user, solution: @solution, emotion: params[:emotion])
    end

    Solution.where(id: solution).update_all(
      "num_reactions = (SELECT COUNT(*) from reactions where solution_id = #{solution.id})"
    )

    @comments = @solution.reactions.with_comments.includes(user: :profile)
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
  end
end


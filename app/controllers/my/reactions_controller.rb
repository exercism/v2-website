class My::ReactionsController < MyController
  def index
    @solutions = Solution.published.joins(:reactions).where("reactions.user_id": current_user).includes({exercise: :track}).distinct.page(params[:page]).per(18)
    @reaction_counts = Reaction.where(solution_id: @solutions.map(&:id)).group(:solution_id, :emotion).count
    @comment_counts = Reaction.where(solution_id: @solutions.map(&:id)).with_comments.group(:solution_id).count
    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }
  end

  def create
    @solution = Solution.published.find_by_uuid!(params[:solution_id])
    @reaction = CreateReaction.(current_user, @solution, params[:emotion])

    @comments = @solution.reactions.with_comments.includes(user: [:profile, { avatar_attachment: :blob }])
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
  end

  def comment
    @solution = Solution.published.find_by_uuid!(params[:solution_id])

    @emotion = Reaction.where(user: current_user, solution: @solution).first.try(:emotion) if user_signed_in?
    @emotion ||= params[:emotion] if Reaction.emotions.keys.include? params[:emotion]
    @emotion ||= "legacy"

    @reaction = Reaction.create!(user: current_user, solution: @solution, emotion: @emotion, comment: params[:comment])
    @comments = @solution.reactions.with_comments.includes(user: [:profile, { avatar_attachment: :blob }])
  end
end

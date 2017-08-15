class My::ReactionsController < MyController
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


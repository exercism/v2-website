class CreateReaction
  include Mandate

  initialize_with :user, :solution, :emotion

  def call
    @reaction = Reaction.where(user: user, solution: solution).first
    if reaction
      if emotion == reaction.emotion
        destroy_reaction
      else
        update_reaction
      end
    else
      create_reaction
    end

    reaction
  end

  private
  attr_reader :reaction

  def create_reaction
    @reaction = Reaction.create!(user: user, solution: solution, emotion: emotion)

    CreateNotification.(
      solution.user,
      :new_reaction,
      "#{strong user.handle} has reacted to your solution to #{strong solution.exercise.title} on the #{strong solution.exercise.track.title} track.",
      routes.solution_url(solution),
      trigger: reaction,

      # We want this to be the solution not the post
      # to allow for clearing without a mentor having to
      # go into every single iteration
      about: solution
    )
    update_solution_reaction_counter
  end

  def update_reaction(emotion_new = emotion)
    reaction.update!(emotion: emotion_new)
  end

  def destroy_reaction
    reaction.destroy!
    Notification.where(user: solution.user, trigger: reaction).delete_all
    update_solution_reaction_counter
  end

  def update_solution_reaction_counter
    Solution.where(id: solution).update_all(
      "num_reactions = (SELECT COUNT(*) from reactions where solution_id = #{solution.id})"
    )
  end

  def routes
    @routes ||= Rails.application.routes.url_helpers
  end

  def strong(text)
    "<strong>#{text}</strong>"
  end
end

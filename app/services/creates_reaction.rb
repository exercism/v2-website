class CreatesReaction
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :user, :solution, :emotion, :reaction
  def initialize(user, solution, emotion)
    @user = user
    @solution = solution
    @emotion = emotion
  end

  def create!
    @reaction = Reaction.where(user: user, solution: solution).first
    if reaction
      if emotion == reaction.emotion
        destroy_reaction unless reaction.comment.present?
      else
        update_reaction
      end
    else
      create_reaction
    end

    reaction
  end

  private

  def create_reaction
    @reaction = Reaction.create!(user: user, solution: solution, emotion: emotion)

    CreatesNotification.create!(
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

  def update_reaction
    reaction.update!(emotion: emotion)
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

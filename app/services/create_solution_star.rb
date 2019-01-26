class CreateSolutionStar
  include Mandate

  initialize_with :user, :solution

  def call
    @solution_star = SolutionStar.where(user: user, solution: solution).first
    if solution_star
      destroy_solution_star
    else
      create_solution_star
    end

    solution_star
  end

  private
  attr_reader :solution_star

  def create_solution_star
    @solution_star = SolutionStar.create!(user: user, solution: solution)

    CreateNotification.(
      solution.user,
      :new_solution_star,
      "#{strong user.handle} has starred your solution to #{strong solution.exercise.title} on the #{strong solution.exercise.track.title} track.",
      routes.solution_url(solution),
      trigger: solution_star,

      # We want this to be the solution not the post
      # to allow for clearing without a mentor having to
      # go into every single iteration
      about: solution
    )
    update_solution_stars_counter
  end

  def destroy_solution_star
    solution_star.destroy!
    Notification.where(user: solution.user, trigger: solution_star).delete_all
    update_solution_stars_counter
  end

  def update_solution_stars_counter
    Solution.where(id: solution).update_all(
      "num_stars = (SELECT COUNT(*) from solution_stars where solution_id = #{solution.id})"
    )
  end

  def routes
    @routes ||= Rails.application.routes.url_helpers
  end

  def strong(text)
    "<strong>#{text}</strong>"
  end
end

class CreatesIteration
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :solution, :code, :iteration
  def initialize(solution, code)
    @solution = solution
    @code = code
  end

  def create!
    @iteration = Iteration.create!(
      solution: solution,
      code: code
    )
    solution.mentorships.update_all(requires_action: true)
    solution.update(last_updated_by_user_at: DateTime.now)
    notify_mentors
    iteration
  end

  def notify_mentors
    solution.mentors.each do |mentor|
      CreatesNotification.create!(
        mentor,
        :new_iteration_for_mentor,
        "#{solution.user.name} has posted a new iteration on a solution you are mentoring",
        "http://foobar.com", # TODO

        # We want this to be the solution not the iteration
        # to allow for clearing without a mentor having to
        # go into every single iteration
        about: solution
      )
      DeliversEmail.deliver!(
        mentor,
        :new_iteration_for_mentor,
        iteration
      )
    end
  end

end

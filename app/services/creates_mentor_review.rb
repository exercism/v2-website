class CreatesMentorReview
  def self.create(*args)
    new(*args).create
  end

  attr_reader :user, :mentor, :solution, :rating, :feedback
  def initialize(user, mentor, solution, rating, feedback)
    @user = user
    @mentor = mentor
    @solution = solution
    @rating = rating
    @feedback = feedback
  end

  def create
    return false unless solution.mentors.include?(mentor)
    return false unless solution.user == user

    # TODO - Check for existing review for this triple and update instead

    MentorReview.create!(
      user: user,
      mentor: mentor,
      solution: solution,
      rating: rating,
      feedback: feedback
    )
  end
end


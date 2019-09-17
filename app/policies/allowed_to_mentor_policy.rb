class AllowedToMentorPolicy
  def self.allowed?(user)
    new(user).allowed?
  end

  def initialize(user)
    @user = user
  end

  def allowed?
    user.solutions.submitted.any?
  end

  private
  attr_reader :user
end

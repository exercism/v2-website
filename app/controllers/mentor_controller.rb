class MentorController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_mentors!

  private

  def restrict_to_mentors!
    return if current_user.is_mentor?
    redirect_to become_a_mentor_path
  end
end

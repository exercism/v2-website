class MentorController < ApplicationController
  before_action :restrict_to_mentors!

  private

  def restrict_to_mentors!
    return if current_user.mentor?
    redirect_to root_path, status: 401
  end
end


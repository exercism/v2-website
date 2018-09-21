class Admin::MentorsController < ApplicationController
  def index
    @user = User.all()
    @mentor = TrackMentorship.all()
  end

  def show
  end

end

class Admin::MentorsController < ApplicationController
  before_action :restrict_to_admins!

  def index
  end
end

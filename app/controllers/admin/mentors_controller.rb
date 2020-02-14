class Admin::MentorsController < AdminController
  before_action :restrict_to_admins!

  def index
  end
end

class Admin::Data::TracksController < AdminController
  before_action :restrict_to_admins!

  def index
    @tracks = Track.order('title ASC')
  end

  def show
    @track = Track.find(params[:id])
    @exercises = @track.exercises.reorder('slug ASC')
  end
end

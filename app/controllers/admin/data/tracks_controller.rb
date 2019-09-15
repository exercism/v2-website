class Admin::Data::TracksController < AdminController
  def index
    @tracks = Track.order('title ASC')
  end

  def show
    @track = Track.find(params[:id])
    @exercises = @track.exercises.reorder('slug ASC')
  end
end

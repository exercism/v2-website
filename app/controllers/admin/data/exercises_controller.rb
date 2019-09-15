class Admin::Data::ExercisesController < AdminController
  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])

    @solutions = @exercise.solutions.submitted.order('id DESC').limit(500)

    zip_path = ExportSolutionsData.(@solutions)
    send_file(zip_path)
  end
end


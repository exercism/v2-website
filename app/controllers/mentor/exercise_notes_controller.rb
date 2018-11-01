class Mentor::ExerciseNotesController < MentorController
  def show
    @track = Track.find_by_slug!(params[:track_id])
    @exercise = @track.exercises.find_by_slug!(params[:exercise_id])
    @notes = RetrieveMentorExerciseNotes.(@track, @exercise)

    respond_to do |format|
      format.js { render_modal("mentor-exercise-notes", :modal, close_button: true) }
      format.html
    end
  end
end

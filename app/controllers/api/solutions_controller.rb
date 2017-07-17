class API::SolutionsController < APIController
  before_action :set_track
  before_action :set_exercise

  def index
    solution = current_user.solutions.where(exercise_id: @exercise.id).order('id asc').last

    render json: {}, status: 403 and return unless solution

    render json: {
      solution: {
        exercise: {
          instructions_url: "",
          test_suite_url: "",
          template_url: ""
        },
        iteration: nil
      }
    }
  end

  def update
    solution = current_user.solutions.find(params[:id])
    render json: {}, status: 403 and return unless solution

    CreatesIteration.create!(solution, params[:code])

    render json: {}, status: 201
  end

  private

  def set_track
    @track = Track.find_by!(slug: params[:track_id])
  end

  def set_exercise
    @exercise = @track.exercises.find_by!(slug: params[:exercise_id])
  end
end

class Maintainers::ConceptExercisesController < ApplicationController
  before_action :set_concept_exercise, only: [:show, :edit, :update, :submit]

  def index
    @concept_exercises = Maintainers::ConceptExercise.where(user_id: current_user.id)
  end

  def show
  end

  def new
    @concept_exercise = Maintainers::ConceptExercise.new
  end

  def create
    @concept_exercise = Maintainers::ConceptExercise.create!(
      concept_exercise_params.merge(
        user: current_user
      )
    )
    redirect_to @concept_exercise
  end

  def update
    @concept_exercise.update!(concept_exercise_params)
    redirect_to @concept_exercise
  end

  def submit
    @concept_exercise.submit!
    redirect_to @concept_exercise
  end

  private
  def concept_exercise_params
    params.require(:maintainers_concept_exercise).permit(
      :name,
      :introduction_content,
      :instructions_content,
      :example_filename,
      :example_content
    )
  end

  def set_concept_exercise
    @concept_exercise = Maintainers::ConceptExercise.where(user_id: current_user.id).find(params[:id])
  end
end

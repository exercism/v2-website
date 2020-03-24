module Research
  class UserExperimentSurveyController < Research::BaseController
    before_action :set_user_experiment

    def show
    end

    def set_history
      @user_experiment.update_survey!(survey_params)
      redirect_to action: :languages
    end

    def languages
      @languages = Track.active.order(:title)
    end

    def set_languages
      @user_experiment.update_survey!(survey_params)
      redirect_to action: :languages_2
    end

    def languages_2
      slugs = @user_experiment.survey['languages'].select{|lang,val|val.to_i == 1}.map(&:first)
      @languages = Track.where(slug: slugs)
    end

    def set_languages_2
      @user_experiment.update_survey!(survey_params)
      redirect_to action: :demographics
    end

    def set_demographics
      @user_experiment.update_survey!(survey_params)
      redirect_to action: :thanks
    end

    private
    def set_user_experiment
      @experiment = Experiment.find(params[:user_experiment_id])
      @user_experiment = UserExperiment.find_by(user: current_user, experiment: @experiment)
    end

    def survey_params
      params.require(:survey).permit!
    end
  end
end

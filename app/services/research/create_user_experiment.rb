module Research
  class CreateUserExperiment
    include Mandate

    initialize_with :user, :experiment

    def call
      atomic do
        UserExperiment.find_or_create_by(
          user: user,
          experiment: experiment,
        )
      end
    end

    private

    def atomic
      yield
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end


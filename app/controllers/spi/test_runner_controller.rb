module SPI
  class TestRunnerController < BaseController
    def languages
      render json: {
        languages: {
          ruby: {
            timeout_ms: 3000,
            container_version: "foobar123",
            num_processors: 2
          },
          javascript: {
            timeout_ms: 5000,
            container_version: "barfood987",
            num_processors: 1
          },
        }
      }
    end

    def submissions_to_test
      ss = Submission.where(tested: false).
                      where("created_at > ?", Time.current - 1.minute).
                      limit(100).
                      includes(solution: {exericse: :track})

      render json: {
        submissions: ss.map {|submission|
          {
            uuid: submission.uuid,
            language_slug: submission.solution.exercise.language_track.slug,
            exercise_slug: submission.solution.exercise.slug,
          }
        }
      }
    end

    def submission_tested
      submission = Submission.find_by_uuid!(params[:submission_uuid])
      SubmissionServices::ProcessTestRun.(
        submission,
        params[:ops_status],
        params[:ops_message],
        params[:results].try {|r| r.permit!.to_h }
      )
      render json: {received: :ok}
    end
  end
end


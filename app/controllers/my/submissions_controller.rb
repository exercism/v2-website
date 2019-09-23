class My::SubmissionsController < MyController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def test_results
    submission = Submission.find(params[:id])
    return render(json: {}, status: :forbidden) unless submission.solution.user_id == current_user.id
    return render(json: {}, status: :failed_dependency) unless submission.tested?

    test_results = submission.test_results.last
    output = {
      status: test_results.results_status
    }

    if test_results.results_status == :error
      output[:message] = test_results.message
    elsif test_results.results_status == :fail
      output[:failure] = test_results.tests.select{|t|t['status'] == 'fail'}.first
    end

    render json: output
  end
end

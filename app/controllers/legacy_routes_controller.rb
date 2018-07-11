class LegacyRoutesController < ApplicationController
  def submission_to_solution
    iteration = Iteration.find_by_legacy_uuid(params[:uuid])
    if iteration
      redirect_to iteration.solution, status: :moved_permanently
    else
      redirect_to root_path, status: :moved_permanently
    end
  end
end

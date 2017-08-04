class TmpController < ApplicationController
  def create_iteration
    @solution = current_user.solutions.find_by_uuid!(params[:solution_id])

    files = (rand(2) + 1).times.map {
      tempfile = Tempfile.new
      tempfile.write("foobar")
      ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: 'foobar.rb', type: 'text/plain')
    }
    CreatesIteration.create!(@solution, files)
    redirect_to [:my, @solution]
  end
end


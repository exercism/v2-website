class TmpController < ApplicationController
  def create_iteration
    @solution = current_user.solutions.find_by_uuid!(params[:solution_id])

    files = (rand(2) + 1).times.map {
      tempfile = Tempfile.new
      tempfile.write("foobar")
      file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, type: 'text/plain')
      file.headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"/lib/three.py\"\r\nContent-Type: application/octet-stream\r\n"
      file
    }
    CreatesIteration.create!(@solution, files)
    redirect_to [:my, @solution]
  end
end


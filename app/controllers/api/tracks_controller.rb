class API::TracksController < APIController
  def setup
    begin
      track = Track.find(params[:id])
    rescue
      return render json: {error: "Track not found", fallback_url: tracks_url}, status: 404
    end

    # TODOGIT - Set test_pattern from git
    test_pattern = Track.first.repo.test_pattern
    render json: {
      track: {
        test_pattern: test_pattern
      }
    }, status: 200
  end
end

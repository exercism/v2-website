class API::TracksController < APIController
  def show
    begin
      track = Track.find(params[:id])
    rescue
      return render json: {error: "Track not found", fallback_url: tracks_url}, status: 404
    end

    test_pattern = Track.first.repo.test_pattern
    render json: {
      track: {
        id: track.slug,
        language: track.title,
        test_pattern: test_pattern
      }
    }, status: 200
  end
end

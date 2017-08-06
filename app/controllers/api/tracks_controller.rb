class API::TracksController < APIController
  def setup
    begin
      track = Track.find(params[:id])
    rescue
      return render json: {error: "Track not found", fallback_url: tracks_url}, status: 404
    end

    render json: {}, status: 200
  end
end

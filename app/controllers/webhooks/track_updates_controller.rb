class Webhooks::TrackUpdatesController < WebhooksController
  MASTER_REF = "refs/heads/master"

  def create
    TrackUpdate.create(track: track) if pushed_to_master?

    render json: {}, status: 200
  end

  private

  def pushed_to_master?
    params[:ref].eql? MASTER_REF
  end

  def track
    Track.find_by!(slug: params[:repository][:name])
  end
end

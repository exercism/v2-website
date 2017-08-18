class Webhooks::TrackUpdatesController < WebhooksController
  MASTER_REF = "refs/heads/master"

  def create
    UpdateTracksJob.perform_later if pushed_to_master?

    render json: {}, status: 200
  end

  private

  def pushed_to_master?
    params[:ref].eql? MASTER_REF
  end
end

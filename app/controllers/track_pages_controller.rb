class TrackPagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  before_action :get_track

  Git::ExercismRepo::PAGES.each do |page|
    define_method page do
      @page = page
      @content = ParseMarkdown.(@track.repo.send(page))
      render action: "show"
    end
  end

  private

  def get_track
    @track = Track.find(params[:track_id])
  end
end

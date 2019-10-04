class ChangelogEntriesController < ApplicationController
  def index
    per_page = params[:per_page] || 20
    @entries = ChangelogEntry.
      published.
      order(published_at: :desc).
      page(params[:page]).
      per(per_page)
  end

  def show
    @entry = ChangelogEntry.find_by_url_slug!(params[:slug])
  end
end

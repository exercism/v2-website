class ChangelogsController < ApplicationController
  def show
    per_page = params[:per_page] || 20
    @entries = ChangelogEntry.
      published.
      order(published_at: :desc).
      page(params[:page]).
      per(per_page)
  end
end

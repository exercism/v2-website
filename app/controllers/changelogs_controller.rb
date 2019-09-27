class ChangelogsController < ApplicationController
  def show
    @entries = ChangelogEntry.published
  end
end

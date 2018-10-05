class Git::UpdateRepos
  include Mandate

  def call
    update_tracks
    update_problem_specs
    update_website_copy
  end

  private

  def update_tracks
    Track.find_each do |track|
      RepoUpdate.create(slug: track.slug)
    end
  end

  def update_problem_specs
    RepoUpdate.create(slug: RepoUpdate::PROBLEM_SPEC_SLUG)
  end

  def update_website_copy
    RepoUpdate.create(slug: RepoUpdate::WEBSITE_COPY_SLUG)
  end
end

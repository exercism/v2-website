class Contributor < ApplicationRecord
  validates_presence_of :github_id, :github_username

  def self.with_contribution(contribution)
    contributor = find_or_initialize_by(github_id: contribution.github_id)
    contributor.avatar_url = contribution.avatar_url
    contributor.github_username = contribution.username
    contributor.num_contributions += 1
    contributor
  end

  def name
    github_username
  end
end

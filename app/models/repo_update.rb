class RepoUpdate < ApplicationRecord
  validates :slug, presence: true
  validates :repo, presence: true

  has_many :repo_update_fetches, dependent: :destroy

  def repo
    case slug
    when "problem-specifications"
      Git::ProblemSpecifications.head
    when "website-copy"
      Git::WebsiteContent.head
    else
      track.repo
    end
  end

  private

  def track
    Track.find_by(slug: slug) || NullTrack.new
  end
end

class RepoUpdate < ApplicationRecord
  PROBLEM_SPEC_SLUG = "problem-specifications"
  WEBSITE_COPY_SLUG = "website-copy"
  BLOG_SLUG = "blog"

  validates :slug, presence: true
  validates :repo, presence: true

  has_many :repo_update_fetches, dependent: :destroy

  def repo
    case slug
    when PROBLEM_SPEC_SLUG
      Git::ProblemSpecifications.head
    when WEBSITE_COPY_SLUG
      Git::WebsiteContent.head
    when BLOG_SLUG
      Git::BlogRepository.head
    else
      track.repo
    end
  end

  private

  def track
    Track.find_by(slug: slug) || NullTrack.new
  end
end

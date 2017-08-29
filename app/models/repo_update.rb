class RepoUpdate < ApplicationRecord
  validates :slug, presence: true

  def repo
    case slug
    when "problem-specifications"
      Git::ProblemSpecifications.head
    when "website-copy"
      Git::WebsiteContent.head
    else
      Track.find_by!(slug: slug).repo
    end
  end
end

class RepoUpdate < ApplicationRecord
  validates :slug, presence: true
end

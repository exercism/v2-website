class Mentor < ApplicationRecord
  belongs_to :track

  validates :name, presence: true
  validates :github_username, presence: true
end

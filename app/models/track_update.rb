class TrackUpdate < ApplicationRecord
  belongs_to :track
  has_many :track_update_fetches

  validates :track, presence: true
end

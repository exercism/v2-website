class TrackUpdate < ApplicationRecord
  belongs_to :track

  validates :track, presence: true
end

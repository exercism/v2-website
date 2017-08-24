class TrackUpdateFetch < ApplicationRecord
  belongs_to :track_update

  validates :track_update, presence: true
  validates :host, presence: true
end

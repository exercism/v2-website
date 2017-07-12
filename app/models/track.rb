class Track < ApplicationRecord
  has_many :user_tracks
  has_many :exercises
  has_many :solutions, through: :exercises
  has_many :iterations, through: :solutions
  has_many :mentored_tracks

  def bordered_icon_url
    'tmp/bordered-track-icon.png'
  end
end

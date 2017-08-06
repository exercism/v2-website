class Testimonial < ApplicationRecord
  belongs_to :track, optional: true

  scope :generic, -> { where(track_id: nil) }
end

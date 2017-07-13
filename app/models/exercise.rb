class Exercise < ApplicationRecord
  belongs_to :track
  belongs_to :unlocked_by, class_name: "Exercise", optional: true

  has_many :unlocks, class_name: "Exercise", foreign_key: :unlocked_by_id
  has_many :solutions
  has_many :iterations, through: :solutions

  def self.core
    where(core: true)
  end

  def self.side
    where(core: false)
  end

  def side?
    !core
  end

  # TODO
  def topics
    ["strings", "transforming", "regular expressions"]
  end

  # TODO
  def icon_url
    'tmp/exercise-icon.png'
  end
end

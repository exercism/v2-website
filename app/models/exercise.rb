class Exercise < ApplicationRecord
  belongs_to :track
  belongs_to :unlocked_by, class_name: "Exercise", optional: true

  has_many :unlocks, class_name: "Exercise", foreign_key: :unlocked_by_id

  def self.core
    where(core: true)
  end
end

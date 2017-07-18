class Maintainer < ApplicationRecord
  belongs_to :track
  belongs_to :user, optional: true

  scope :active, -> { where(active: true) }
  scope :visible, -> { where(visible: true) }
end

class Maintainer < ApplicationRecord
  belongs_to :track
  belongs_to :user, optional: true

  scope :active, -> { where(alumnus: nil) }
  scope :visible, -> { where(visible: true) }

  def active?
    alumnus.blank?
  end
end

class Notification < ApplicationRecord
  self.inheritance_column = 'does_not_have_one'

  belongs_to :user
  belongs_to :about, polymorphic: true, optional: true

  def self.unread
    where(read: false)
  end
end

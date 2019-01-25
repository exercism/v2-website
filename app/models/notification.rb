class Notification < ApplicationRecord
  self.inheritance_column = 'does_not_have_one'

  belongs_to :user
  belongs_to :about, polymorphic: true, optional: true
  belongs_to :trigger, polymorphic: true, optional: true

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }
end

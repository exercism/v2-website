class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :about, polymorphic: true, optional: true
end

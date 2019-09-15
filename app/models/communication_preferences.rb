class CommunicationPreferences < ApplicationRecord
  belongs_to :user

  before_create do
    self.token = SecureRandom.uuid
  end
end

class TeamInvitation < ApplicationRecord
  belongs_to :team
  belongs_to :invited_by, class_name: "User"

  def self.for_user(user)
    self.where(email: user.email)
  end
end

class TeamInvitation < ApplicationRecord
  belongs_to :team
  belongs_to :invited_by, class_name: "User"

  delegate :name, to: :invited_by, prefix: "inviter"

  def self.for_user(user)
    self.where(email: user.email)
  end
end

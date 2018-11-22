class TeamInvitation < ApplicationRecord
  belongs_to :team
  belongs_to :invited_by, class_name: "User"

  delegate :name, to: :invited_by, prefix: "inviter"
  delegate :name, to: :team, prefix: true

  has_secure_token :token

  def self.for_user(user)
    self.where(email: user.email)
  end

  def to_param
    token
  end
end

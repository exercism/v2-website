class Team < ApplicationRecord
  has_many :memberships, class_name: "TeamMembership"
  has_many :invitations, class_name: "TeamInvitation"
end

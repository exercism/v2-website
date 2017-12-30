class Team < ApplicationRecord
  has_many :memberships, class_name: "TeamMembership"
end

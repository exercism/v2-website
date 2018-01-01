class TeamMembership < ApplicationRecord

  class InvalidMembership < RuntimeError
  end

  belongs_to :team
  belongs_to :user
end

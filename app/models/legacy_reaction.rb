class LegacyReaction < ApplicationRecord
  belongs_to :solution
  belongs_to :user
end

class DiscussionPost < ApplicationRecord
  belongs_to :iteration
  belongs_to :user
end

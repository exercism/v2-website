class MentorReview < ApplicationRecord
  belongs_to :user
  belongs_to :mentor, class_name: "User"
  belongs_to :solution
end

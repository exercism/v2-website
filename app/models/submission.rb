class Submission < ApplicationRecord
  belongs_to :solution

  has_many_attached :files
end

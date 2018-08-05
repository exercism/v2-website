class SolutionLock < ApplicationRecord
  belongs_to :solution
  belongs_to :user
end

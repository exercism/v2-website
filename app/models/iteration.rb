class Iteration < ApplicationRecord
  belongs_to :solution
  has_many :files, class_name: "IterationFile"
  has_many :discussion_posts
  has_many :notifications, as: :about

  enum mentor_status: [:pending, :reply, :refactor, :approved]
end

class Iteration < ApplicationRecord
  belongs_to :solution, polymorphic: true
  has_many :files, class_name: "IterationFile", dependent: :destroy
  has_many :discussion_posts
  has_many :notifications, as: :about
end

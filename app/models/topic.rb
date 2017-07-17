class Topic < ApplicationRecord
  has_many :exercise_topics
  has_many :exercises, through: :exercise_topics

  before_create do
    self.name = slug.titleize unless name
  end
end

class Exercise < ApplicationRecord
  belongs_to :track
  belongs_to :unlocked_by, class_name: "Exercise", optional: true

  has_many :exercise_topics
  has_many :topics, through: :exercise_topics

  has_many :unlocks, class_name: "Exercise", foreign_key: :unlocked_by_id
  has_many :solutions
  has_many :iterations, through: :solutions

  default_scope -> { order('position ASC, title ASC') }
  scope :active, -> { where(active: true) }
  scope :core, -> { where(core: true) }
  scope :side, -> { where(core: false) }

  def side?
    !core
  end

  def topic_names
    @topic_names ||= topics.pluck(:name)
  end

  # TODO
  def icon_url
    'tmp/exercise-icon.png'
  end
end

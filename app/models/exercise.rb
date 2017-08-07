class Exercise < ApplicationRecord
  extend FriendlyId
  friendly_id do |fid|
    fid.use [:history, :scoped]
    fid.scope = :track_id
  end

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
    @topic_names ||= topics.pluck(:name).map(&:downcase)
  end

  def description
    ParsesMarkdown.parse(%q{
The classical introductory exercise. Just say "Hello, World!".

["Hello, World!"](http://en.wikipedia.org/wiki/%22Hello,_world!%22_program) is
the traditional first program for beginning programming in a new language
or environment.

The objectives are simple:

- Write a function that returns the string "Hello, World!".
- Run the test suite and make sure that it succeeds.
- Submit your solution and check it at the website.

If everything goes well, you will be ready to fetch your first real exercise.

})
  end

  # TODO
  def white_icon_url
    super || 'tmp/exercise-icon-white.png'
  end

  # TODO
  def dark_icon_url
    super || 'tmp/exercise-icon-dark.png'
  end

  # TODO
  def turquoise_icon_url
    super || 'tmp/exercise-icon-turquoise.png'
  end

  # TODO
  def icon_url
    raise "Deprecated"
  end
end

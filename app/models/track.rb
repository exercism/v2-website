class Track < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:history]

  has_many :user_tracks
  has_many :exercises
  has_many :solutions, through: :exercises
  has_many :iterations, through: :solutions
  has_many :mentorships, class_name: "TrackMentorship"
  has_many :mentors, through: :mentorships, source: :user
  has_many :maintainers

  # TODO
  def bordered_icon_url
    'tmp/track-hex-green-bordered.png'
  end

  # TODO
  def bordered_turqioise_icon_url
    'tmp/track-hex-turquoise-bordered.png'
  end

  # TODO
  def hex_icon_url
    'tmp/track-hex-green.png'
  end

  # TODO
  def hex_turqioise_icon_url
    'tmp/track-hex-turquoise.png'
  end

  # TODO
  def hex_white_icon_url
    'tmp/track-hex-white.png'
  end

  # TODO
  def introduction
    "Since the announcement that it's being sunsetted, I want to tell you about the strangest Since the announcement that it's being sunsetted, I want to tell you about the strangest thing I know about Flash and Adobe."
  end

  # TODO
  def about
    ParsesMarkdown.parse(%Q{ Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.\n
Ruby was created as a language of careful balance. Its creator, [Yukihiro “Matz” Matsumoto](https://en.wikipedia.org/wiki/Yukihiro_Matsumoto), blended parts of his favorite languages (Perl, Smalltalk, Eiffel, Ada, and Lisp) to form a new language that balanced functional programming with imperative programming.\n
He has often said that he is "trying to make Ruby natural, not simple," in a way that mirrors life.})
  end
end

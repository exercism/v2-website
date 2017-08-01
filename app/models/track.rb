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

  [:bordered_green_icon_url,
   :bordered_turquoise_icon_url,
   :hex_green_icon_url,
   :hex_turquoise_icon_url,
   :hex_white_icon_url,
   :hex_green_icon_url,
  ].each do |icon|
    define_method icon do
      super() || "tmp/track-#{icon.to_s.dasherize}.png"
    end
  end

  # TODO
  def introduction
    "Since the announcement that it's being sunsetted, I want to tell you about the strangest Since the announcement that it's being sunsetted, I want to tell you about the strangest thing I know about Flash and Adobe."
  end

  # TODO
  def about
    ParsesMarkdown.parse(super)
#%Q{ Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.\n
#Ruby was created as a language of careful balance. Its creator, [Yukihiro “Matz” Matsumoto](https://en.wikipedia.org/wiki/Yukihiro_Matsumoto), blended parts of his favorite languages (Perl, Smalltalk, Eiffel, Ada, and Lisp) to form a new language that balanced functional programming with imperative programming.\n
#He has often said that he is "trying to make Ruby natural, not simple," in a way that mirrors life.})
  end
end

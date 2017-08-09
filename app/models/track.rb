class Track < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:history]

  has_many :testimonials
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
      super() || "https://s3-eu-west-1.amazonaws.com/exercism-static/tracks/default-#{icon.to_s.gsub(/_icon_url/,'').dasherize}.png"
    end
  end

  def about
    ParsesMarkdown.parse(super)
  end

  def repo
    Git::ExercismRepo.new(repo_url)
  end
end

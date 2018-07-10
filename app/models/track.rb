class Track < ApplicationRecord
  extend FriendlyId

  friendly_id :slug, use: [:history]

  has_many :testimonials
  has_many :user_tracks
  has_many :exercises
  has_many :solutions, through: :exercises
  has_many :iterations, through: :solutions
  has_many :mentorships, class_name: "TrackMentorship"

  has_many :maintainers
  has_many :mentors

  scope :active, ->{ where(active: true) }

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

  def introduction
    i = super
    i.present?? i : "TODO: The maintainers have not provided a description for this track."
  end

  def about
    repo.about.present?? ParsesMarkdown.parse(repo.about) : nil
  end

  def repo
    Git::ExercismRepo.new(repo_url)
  end
end

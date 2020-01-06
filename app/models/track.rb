class Track < ApplicationRecord
  extend FriendlyId

  friendly_id :slug, use: [:history]

  has_many :testimonials
  has_many :user_tracks
  has_many :exercises, -> { order position: :asc, title: :asc }
  has_many :solutions, through: :exercises
  has_many :iterations, through: :solutions
  has_many :mentorships, class_name: "TrackMentorship"

  has_many :maintainers
  has_many :mentors

  scope :active, ->{ where(active: true) }

  delegate :head, to: :repo

  [:bordered_green_icon_url,
   :bordered_turquoise_icon_url,
   :hex_green_icon_url,
   :hex_turquoise_icon_url,
   :hex_white_icon_url,
   :hex_green_icon_url,
  ].each do |icon|
    define_method icon do
      super() || "https://assets.exercism.io/tracks/default-#{icon.to_s.gsub(/_icon_url/,'').dasherize}.png"
    end
  end

  def introduction
    i = super
    i.present?? i : "TODO: The maintainers have not provided an introduction for this track."
  end

  def about
    repo.about.present?? ParseMarkdown.(repo.about) : nil
  end

  def editor_config
    { language: slug }.merge(repo.editor_config)
  end

  def repo
    Git::ExercismRepo.new(repo_url)
  end

  def research_track?
    slug.starts_with?("research")
  end

  def accepting_new_students?
    # If we have a median time then use it as the guage
    return median_wait_time < 1.week if median_wait_time 

    # Otherwise check whether there are <20 in the queue
    SolutionsToBeMentored.new(nil, [id], []).mentored_core_solutions.count < 10
  end
end

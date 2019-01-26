class Profile < ApplicationRecord
  belongs_to :user

  def to_param
    user.handle
  end

  def has_external_links?
    website.present? || github.present? || twitter.present? ||
    linkedin.present? || medium.present?
  end

  def solutions
    user.
    solutions.
    published.
    joins(:exercise).
    joins("INNER JOIN user_tracks ON user_tracks.track_id = exercises.track_id").
    where("user_tracks.user_id = #{user_id}").
    where("user_tracks.anonymous": false).
    reorder('solutions.num_stars DESC')
  end
end

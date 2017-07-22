class TrackMentorship < ApplicationRecord
  belongs_to :user
  belongs_to :track

  def handle
    super || user.handle
  end

  def avatar_url
    super || user.avatar_url
  end

  def bio
    super || user.bio
  end
end

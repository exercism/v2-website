class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_tracks
  has_many :tracks, through: :user_tracks
  has_many :solutions
  has_many :iteractions, through: :solutions
  has_many :mentored_tracks
  has_many :auth_tokens

  def unlocked_track?(track)
    user_tracks.where(track_id: track.id).exists?
  end

  def mentor?
    mentored_tracks.exists?
  end
end

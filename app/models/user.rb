class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_tracks
  has_many :tracks, through: :user_tracks

  def unlocked_track?(track)
    user_tracks.where(track_id: track.id).exists?
  end
end

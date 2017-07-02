class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :auth_tokens

  has_many :notifications

  has_many :user_tracks
  has_many :tracks, through: :user_tracks
  has_many :solutions
  has_many :iteractions, through: :solutions
  has_many :mentored_tracks

  def avatar_url
    "http://lorempixel.com/400/400/"
  end

  def unlocked_track?(track)
    user_tracks.where(track_id: track.id).exists?
  end

  def mentor?
    mentored_tracks.exists?
  end
end

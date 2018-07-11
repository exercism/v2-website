class User < ApplicationRecord
  DEFAULT_AVATAR = "anonymous.png"

  # Remove this so devise can't use it.
  def self.validates_uniqueness_of(*args)
  end

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :auth_tokens, dependent: :destroy
  has_one :communication_preferences, dependent: :destroy

  has_one :profile, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :managed_teams, -> { where(team_memberships: { admin: true }) }, through: :team_memberships, source: :team

  has_many :user_tracks, dependent: :destroy
  has_many :tracks, through: :user_tracks
  has_many :solutions, dependent: :destroy
  has_many :iterations, through: :solutions

  has_many :team_solutions, dependent: :destroy
  has_many :team_iterations, through: :team_solutions, source: :iterations

  has_many :track_mentorships, dependent: :destroy
  has_many :mentored_tracks, through: :track_mentorships, source: :track
  has_many :track_mantainerships, class_name: "Maintainer", dependent: :nullify
  has_many :maintained_tracks, through: :track_mantainerships, source: :track

  has_many :solution_mentorships, dependent: :destroy
  has_many :mentored_solutions, through: :solution_mentorships, source: :solution

  has_many :ignored_solution_mentorships, dependent: :destroy
  has_many :ignored_solutions, through: :ignored_solution_mentorships, source: :solution

  has_many :reactions, dependent: :destroy

  has_many :discussion_posts, dependent: :nullify

  validates :email, uniqueness: {message: "address is already registered. Try <a href='/users/sign_in'>logging in</a> or <a href='/users/password/new'> resetting your password</a>."}, allow_blank: true, if: :will_save_change_to_email?
  validates :handle, presence: true, handle: true

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"]
        user.name = data["info"]["name"] if user.name.blank?
        user.email = data["info"]["email"] if user.email.blank?
        user.handle = data["info"]["nickname"] if user.handle.blank?
      end
    end
  end

  after_create do
    create_communication_preferences
  end

  def auth_token
    @auth_token ||= auth_tokens.first.token
  end

  def onboarded?
    accepted_terms_at.present? &&
    accepted_privacy_policy_at.present?
  end

  def avatar_url
    img = super
    img.present?? img : User::DEFAULT_AVATAR
  end

  def may_view_solution?(solution)
    return true if id == solution.user_id

    if solution.team_solution?
      return true if solution.team.members.include?(self)
    else
      return true if solution.published?
      return true if mentoring_track?(solution.exercise.track)
    end

    false
  end

  def previously_joined_track?(track)
    user_tracks.
      archived.
      where(track_id: track.id).
      exists?
  end

  def joined_track?(track)
    user_tracks.where(track_id: track.id).exists?
  end

  def user_track_for(track)
    user_tracks.where(track_id: track.id).first
  end

  def may_unlock_exercise?(user_track, exercise)
    # If one of:
    # - we're in indepdenent mode
    # - this is a side exercise that has no unlocked_by
    # then we create a solution to unlock it.
    user_track.try(:independent_mode?) || (!exercise.core && !exercise.unlocked_by)
  end

  def mentor?
    track_mentorships.exists?
  end

  def mentoring_track?(track)
    track_mentorships.where(track_id: track.id).exists?
  end

  def mentoring_solution?(solution)
    solution_mentorships.where(solution_id: solution.id).exists?
  end

  def test_user?
    return false if email.blank?
    return true  if email.downcase.include?('+testexercismuser')
    false
  end
end

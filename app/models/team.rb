class Team < ApplicationRecord
  extend FriendlyId
  DEFAULT_AVATAR = "track-page-students.png"

  friendly_id :slug_candidates, use: :slugged

  has_one_attached :avatar

  validate :avatar_is_correct_file_type

  def slug_candidates
    [
      :name,
      [:name, -> { SecureRandom.uuid.split("-").first }],
    ]
  end

  has_many :solutions, class_name: "TeamSolution"
  has_many :iterations, through: :solutions

  has_many :invitations, class_name: "TeamInvitation"
  has_many :memberships, class_name: "TeamMembership"
  has_many :members, through: :memberships, source: :user

  has_secure_token :token

  def avatar_url
    if avatar.attached?
      avatar_thumbnail_url
    else
      Team::DEFAULT_AVATAR
    end
  rescue
    # If ActiveStorage fails or something weird happens
    # don't blow the whole site, just return *something*
    Team::DEFAULT_AVATAR
  end


  def admin?(user)
    memberships.where(admin: true).where(user_id: user.id).exists?
  end

  private
  def avatar_is_correct_file_type
    return unless avatar.attached?

    unless avatar.variable?
      avatar.purge
      errors[:avatar] << "Wrong format"
    end
  end

  def avatar_thumbnail_url
    avatar_thumbnail = avatar.variant(
      combine_options: {
        thumbnail: "200x200^",
        extent: "200x200",
        gravity: :center
      }
    )

    Rails.application.routes.url_helpers.url_for(avatar_thumbnail)
  end

end

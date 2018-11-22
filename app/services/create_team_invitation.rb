class CreateTeamInvitation
  include Mandate

  initialize_with :team, :invited_by, :email

  def call
    ActiveRecord::Base.transaction do
      return if existing_user? && team.memberships.where(user: existing_user).exists?

      create_invite!
      send_invite!
    end
  end

  private

  attr_reader :invite

  def create_invite!
    @invite = team.invitations.create!(
      email: email,
      invited_by: invited_by
    )
  end

  def send_invite!
    if existing_user?
      TeamInviteMailer.existing_user(invite).deliver_later
    else
      TeamInviteMailer.new_user(invite).deliver_later
    end
  end

  def existing_user?
    existing_user.present?
  end

  memoize
  def existing_user
    User.find_by(email: email)
  end
end

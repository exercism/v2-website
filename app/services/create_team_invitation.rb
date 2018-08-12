class CreateTeamInvitation
  include Mandate

  attr_reader :team, :invited_by, :email

  def initialize(team, invited_by, email)
    @team = team
    @invited_by = invited_by
    @email = email
  end

  def call
    create_invite!
    send_invite!

    team
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
    User.find_by(email: invite.email).present?
  end
end

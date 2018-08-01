class ClearNotifications
  include Mandate

  attr_reader :user, :about
  def initialize(user, about)
    @user = user
    @about = about
  end

  def call
    Notification.where(user: user, about: about).update_all(read: true)
  end
end

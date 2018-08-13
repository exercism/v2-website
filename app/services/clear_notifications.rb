class ClearNotifications
  include Mandate

  initialize_with :user, :about

  def call
    Notification.where(user: user, about: about).update_all(read: true)
  end
end

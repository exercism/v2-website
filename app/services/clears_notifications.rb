class ClearsNotifications
  def self.clear!(*args)
    new(*args).clear!
  end

  attr_reader :user, :about
  def initialize(user, about)
    @user = user
    @about = about
  end

  def clear!
    Notification.where(user: user, about: about).update_all(read: true)
  end
end

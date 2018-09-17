class My::NotificationsController < MyController
  def index
    @notifications = current_user.notifications.unread.page(params[:page]).per(20)
  end

  def all
    @notifications = current_user.notifications.page(params[:page]).per(20)
  end

  def read
    current_user.notifications.find(params[:id]).update(read: true)
    head 200
  end

  def read_batch
    Notification.where(id: params[:ids]).update_all(read: true)
    head 200
  end
end

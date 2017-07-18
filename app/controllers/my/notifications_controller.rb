class My::NotificationsController < MyController
  def index
    @notifications = current_user.notifications.unread.page(params[:page]).per(20)
  end
end

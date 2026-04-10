class NotificationsController < ApplicationController
  def index
    @notifications = Current.user.notifications.order(created_at: :desc)
  end

  def mark_as_read
    notification = Current.user.notifications.find(params[:id])
    notification.mark_as_read!
    redirect_back fallback_location: notifications_path
  end

  def mark_all_as_read
    Current.user.notifications.unread.update_all(is_read: true, read_at: Time.current)
    redirect_to notifications_path, notice: "모든 알림을 읽음 처리했습니다."
  end
end

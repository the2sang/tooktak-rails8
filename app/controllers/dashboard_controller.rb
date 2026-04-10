class DashboardController < ApplicationController
  def show
    @projects = Project.where(status: :in_progress).includes(:contractor, :manager).limit(10)
    @recent_issues = Issue.where(status: [:open, :in_progress]).includes(:project, :assigned_to).order(created_at: :desc).limit(5)
    @recent_work_orders = WorkOrder.where(status: [:pending, :in_progress]).includes(:project, :assigned_to).order(created_at: :desc).limit(5)
    @notifications = Current.user&.notifications&.unread&.recent&.limit(5) || Notification.none
  end
end

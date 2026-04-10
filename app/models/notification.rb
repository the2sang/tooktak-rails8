class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  enum :notification_type, { info: 0, warning: 1, alert: 2, approval_request: 3, status_change: 4 }

  validates :title, presence: true

  scope :unread, -> { where(is_read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update!(is_read: true, read_at: Time.current)
  end
end

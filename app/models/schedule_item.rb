class ScheduleItem < ApplicationRecord
  belongs_to :schedule
  belongs_to :parent, class_name: "ScheduleItem", optional: true
  belongs_to :work_order, optional: true
  belongs_to :category, class_name: "WorkCategory", optional: true

  has_many :children, class_name: "ScheduleItem", foreign_key: :parent_id, dependent: :destroy

  enum :status, { not_started: 0, in_progress: 1, completed: 2, delayed: 3, cancelled: 4 }, prefix: true

  validates :name, presence: true
end

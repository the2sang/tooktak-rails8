class Attendance < ApplicationRecord
  belongs_to :project
  belongs_to :worker
  belongs_to :recorded_by, class_name: "User", optional: true

  validates :work_date, presence: true
  validates :worker_id, uniqueness: { scope: [:project_id, :work_date] }
end

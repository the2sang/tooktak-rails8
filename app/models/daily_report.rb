class DailyReport < ApplicationRecord
  belongs_to :project
  belongs_to :created_by, class_name: "User"
  belongs_to :approved_by, class_name: "User", optional: true

  has_many :items, class_name: "DailyReportItem", foreign_key: :report_id, dependent: :destroy

  validates :report_date, presence: true
  validates :report_date, uniqueness: { scope: [:project_id, :created_by_id] }
end

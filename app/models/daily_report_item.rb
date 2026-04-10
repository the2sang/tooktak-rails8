class DailyReportItem < ApplicationRecord
  belongs_to :report, class_name: "DailyReport"
  belongs_to :work_order, optional: true
  belongs_to :category, class_name: "WorkCategory", optional: true

  validates :description, presence: true
end

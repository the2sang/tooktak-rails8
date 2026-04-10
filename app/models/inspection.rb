class Inspection < ApplicationRecord
  belongs_to :project
  belongs_to :work_order, optional: true
  belongs_to :template, class_name: "InspectionTemplate", optional: true
  belongs_to :inspector, class_name: "User", optional: true
  belongs_to :created_by, class_name: "User", optional: true

  has_many :results, class_name: "InspectionResult", dependent: :destroy
  has_many :documents, dependent: :nullify

  enum :inspection_type, { pre_work: 0, in_progress: 1, final: 2, safety: 3, quality: 4, defect: 5 }
  enum :status, {
    scheduled: 0, status_in_progress: 1, passed: 2, failed: 3, conditionally_passed: 4
  }, prefix: :inspection

  validates :title, presence: true
end

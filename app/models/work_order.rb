class WorkOrder < ApplicationRecord
  belongs_to :project
  belongs_to :category, class_name: "WorkCategory", optional: true
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :subcontract, optional: true
  belongs_to :parent_order, class_name: "WorkOrder", optional: true

  has_many :child_orders, class_name: "WorkOrder", foreign_key: :parent_order_id, dependent: :nullify
  has_many :daily_report_items, dependent: :nullify
  has_many :inspections, dependent: :nullify
  has_many :issues, dependent: :nullify
  has_many :material_orders, dependent: :nullify
  has_many :documents, dependent: :nullify
  has_many :costs, dependent: :nullify

  enum :status, {
    draft: 0, pending: 1, approved: 2, in_progress: 3,
    completed: 4, rejected: 5, cancelled: 6
  }, prefix: true
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }

  validates :order_no, presence: true, uniqueness: true
  validates :title, presence: true
end

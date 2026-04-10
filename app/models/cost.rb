class Cost < ApplicationRecord
  belongs_to :project
  belongs_to :work_order, optional: true
  belongs_to :subcontract, optional: true
  belongs_to :recorded_by, class_name: "User", optional: true

  enum :category, { labor: 0, material: 1, equipment: 2, subcontract: 3, overhead: 4, other: 5 }, prefix: :cost
  enum :payment_status, { pending: 0, partial: 1, paid: 2, overdue: 3, cancelled: 4 }, prefix: :payment

  validates :description, presence: true
  validates :amount, presence: true
  validates :cost_date, presence: true
end

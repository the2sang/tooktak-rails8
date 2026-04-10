class MaterialOrder < ApplicationRecord
  belongs_to :project
  belongs_to :material
  belongs_to :supplier, class_name: "Company", optional: true
  belongs_to :work_order, optional: true
  belongs_to :created_by, class_name: "User", optional: true

  enum :status, {
    planned: 0, ordered: 1, delivered: 2, in_use: 3,
    consumed: 4, returned: 5, wasted: 6
  }, prefix: true

  validates :order_no, presence: true, uniqueness: true
  validates :planned_qty, presence: true
end

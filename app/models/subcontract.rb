class Subcontract < ApplicationRecord
  belongs_to :project
  belongs_to :subcontractor, class_name: "Company"
  belongs_to :manager, class_name: "User", optional: true

  has_many :work_orders, dependent: :nullify
  has_many :costs, dependent: :nullify

  enum :status, {
    planning: 0, bidding: 1, contracted: 2, in_progress: 3,
    on_hold: 4, completed: 5, cancelled: 6
  }, prefix: true

  validates :work_scope, presence: true
  validates :contract_amount, presence: true
end

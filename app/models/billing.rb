class Billing < ApplicationRecord
  belongs_to :project
  belongs_to :created_by, class_name: "User", optional: true

  enum :payment_status, { pending: 0, partial: 1, paid: 2, overdue: 3, cancelled: 4 }, prefix: :payment

  validates :billing_no, presence: true, uniqueness: true
  validates :billing_month, presence: true
  validates :progress_rate, presence: true
  validates :claim_amount, presence: true
end

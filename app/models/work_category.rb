class WorkCategory < ApplicationRecord
  belongs_to :parent, class_name: "WorkCategory", optional: true
  has_many :children, class_name: "WorkCategory", foreign_key: :parent_id, dependent: :destroy

  has_many :work_orders, foreign_key: :category_id, inverse_of: :category
  has_many :inspection_templates, foreign_key: :category_id, inverse_of: :category

  validates :name, presence: true
  validates :code, uniqueness: true, allow_nil: true

  scope :active, -> { where(is_active: true) }
  scope :roots, -> { where(parent_id: nil) }
  scope :sorted, -> { order(:sort_order) }
end

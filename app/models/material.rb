class Material < ApplicationRecord
  belongs_to :supplier, class_name: "Company", optional: true

  has_many :material_orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :unit, presence: true
  validates :code, uniqueness: true, allow_nil: true

  scope :active, -> { where(is_active: true) }
end

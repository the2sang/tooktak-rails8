class InspectionTemplate < ApplicationRecord
  belongs_to :category, class_name: "WorkCategory", optional: true

  has_many :items, class_name: "InspectionTemplateItem", foreign_key: :template_id, dependent: :destroy
  has_many :inspections, foreign_key: :template_id

  validates :name, presence: true

  scope :active, -> { where(is_active: true) }
end

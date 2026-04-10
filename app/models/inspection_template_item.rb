class InspectionTemplateItem < ApplicationRecord
  belongs_to :template, class_name: "InspectionTemplate"

  has_many :inspection_results, foreign_key: :template_item_id, dependent: :nullify

  validates :item, presence: true
end

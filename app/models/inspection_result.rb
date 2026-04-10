class InspectionResult < ApplicationRecord
  belongs_to :inspection
  belongs_to :template_item, class_name: "InspectionTemplateItem", optional: true

  validates :item, presence: true
end

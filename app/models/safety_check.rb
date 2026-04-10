class SafetyCheck < ApplicationRecord
  belongs_to :project
  belongs_to :checker, class_name: "User", optional: true

  has_many :items, class_name: "SafetyCheckItem", dependent: :destroy

  validates :check_date, presence: true
end

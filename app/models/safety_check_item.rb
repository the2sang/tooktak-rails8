class SafetyCheckItem < ApplicationRecord
  belongs_to :safety_check

  validates :item, presence: true
end

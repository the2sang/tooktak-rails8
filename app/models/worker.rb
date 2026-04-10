class Worker < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :company, optional: true

  has_many :attendances, dependent: :destroy
  has_many :safety_training_attendees, dependent: :destroy
  has_many :safety_trainings, through: :safety_training_attendees, source: :training

  validates :name, presence: true

  scope :active, -> { where(is_active: true) }
end

class SafetyTraining < ApplicationRecord
  belongs_to :project
  belongs_to :trainer, class_name: "User", optional: true

  has_many :attendees, class_name: "SafetyTrainingAttendee", foreign_key: :training_id, dependent: :destroy
  has_many :workers, through: :attendees

  validates :training_date, presence: true
  validates :title, presence: true
end

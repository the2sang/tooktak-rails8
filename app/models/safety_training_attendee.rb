class SafetyTrainingAttendee < ApplicationRecord
  belongs_to :training, class_name: "SafetyTraining"
  belongs_to :worker

  validates :worker_id, uniqueness: { scope: :training_id }
end

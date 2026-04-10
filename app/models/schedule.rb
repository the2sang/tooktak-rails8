class Schedule < ApplicationRecord
  belongs_to :project
  belongs_to :created_by, class_name: "User", optional: true

  has_many :items, class_name: "ScheduleItem", dependent: :destroy

  validates :name, presence: true
end

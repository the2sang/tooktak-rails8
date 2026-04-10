class Project < ApplicationRecord
  belongs_to :client_company, class_name: "Company", optional: true
  belongs_to :contractor, class_name: "Company", optional: true
  belongs_to :manager, class_name: "User", optional: true
  belongs_to :created_by, class_name: "User", optional: true

  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user
  has_many :subcontracts, dependent: :destroy
  has_many :work_orders, dependent: :destroy
  has_many :daily_reports, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :inspections, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :costs, dependent: :destroy
  has_many :billings, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :safety_checks, dependent: :destroy
  has_many :safety_trainings, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :notifications, dependent: :destroy

  enum :project_type, {
    new_construction: 0, renovation: 1, repair: 2, interior: 3,
    civil: 4, mechanical: 5, electrical: 6, plumbing: 7, other: 8
  }
  enum :status, {
    planning: 0, bidding: 1, contracted: 2, in_progress: 3,
    on_hold: 4, completed: 5, cancelled: 6
  }, prefix: true

  validates :project_no, presence: true, uniqueness: true
  validates :name, presence: true
end

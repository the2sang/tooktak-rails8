class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :company, optional: true

  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members
  has_many :managed_projects, class_name: "Project", foreign_key: :manager_id, inverse_of: :manager
  has_many :notifications, dependent: :destroy

  enum :role, { admin: 0, manager: 1, supervisor: 2, worker: 3, client: 4 }
  enum :status, { active: 0, inactive: 1, pending: 2, suspended: 3 }, prefix: :account

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
end

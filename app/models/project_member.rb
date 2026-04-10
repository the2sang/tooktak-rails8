class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum :role, { admin: 0, manager: 1, supervisor: 2, worker: 3, client: 4 }

  validates :user_id, uniqueness: { scope: :project_id }

  scope :active, -> { where(is_active: true) }
end

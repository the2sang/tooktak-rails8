class AuditLog < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project, optional: true

  validates :table_name, presence: true
  validates :record_id, presence: true
  validates :action, presence: true, inclusion: { in: %w[INSERT UPDATE DELETE] }

  scope :recent, -> { order(created_at: :desc) }
end

class Issue < ApplicationRecord
  belongs_to :project
  belongs_to :work_order, optional: true
  belongs_to :category, class_name: "WorkCategory", optional: true
  belongs_to :reported_by, class_name: "User", optional: true
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :resolved_by, class_name: "User", optional: true

  has_many :comments, class_name: "IssueComment", dependent: :destroy
  has_many :documents, dependent: :nullify

  enum :status, { open: 0, in_progress: 1, resolved: 2, closed: 3, rejected: 4 }, prefix: :issue
  enum :severity, { critical: 0, major: 1, minor: 2, trivial: 3 }

  validates :issue_no, presence: true, uniqueness: true
  validates :title, presence: true
end

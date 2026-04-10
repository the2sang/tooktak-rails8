class IssueComment < ApplicationRecord
  belongs_to :issue
  belongs_to :author, class_name: "User"

  validates :content, presence: true
end

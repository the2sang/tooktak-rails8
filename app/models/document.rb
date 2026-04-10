class Document < ApplicationRecord
  belongs_to :project
  belongs_to :work_order, optional: true
  belongs_to :issue, optional: true
  belongs_to :inspection, optional: true
  belongs_to :uploaded_by, class_name: "User", optional: true

  enum :doc_type, {
    blueprint: 0, specification: 1, contract: 2, permit: 3,
    report: 4, photo: 5, video: 6, other: 7
  }

  validates :title, presence: true
end

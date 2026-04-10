class Company < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :workers, dependent: :nullify
  has_many :contracted_projects, class_name: "Project", foreign_key: :contractor_id, inverse_of: :contractor
  has_many :client_projects, class_name: "Project", foreign_key: :client_company_id, inverse_of: :client_company
  has_many :subcontracts, foreign_key: :subcontractor_id, inverse_of: :subcontractor

  enum :company_type, { general_contractor: 0, subcontractor: 1, supplier: 2, client: 3, consultant: 4 }

  validates :name, presence: true

  scope :active, -> { where(is_active: true) }
end

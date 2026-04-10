class User < ApplicationRecord
  has_secure_password validations: false
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
  validates :password, length: { minimum: 12 }, if: -> { password_digest.present? && password.present? }

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth.provider, uid: auth.uid).tap do |user|
      user.email_address = auth.info.email
      user.name         = auth.info.name.presence || auth.info.email.split("@").first
      user.avatar_url_oauth = auth.info.image
      user.save!
    end
  rescue ActiveRecord::RecordNotUnique
    find_by(provider: auth.provider, uid: auth.uid)
  end
end

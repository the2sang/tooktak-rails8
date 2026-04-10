class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false, limit: 200
      t.string :business_no, limit: 20
      t.integer :company_type, null: false, default: 0  # enum: general_contractor, subcontractor, supplier, client, consultant
      t.string :ceo_name, limit: 100
      t.text :address
      t.string :phone, limit: 20
      t.string :email, limit: 200
      t.string :website, limit: 300
      t.string :logo_url
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
    add_index :companies, :business_no, unique: true

    create_table :users do |t|
      t.references :company, foreign_key: true
      t.string :email_address, null: false, limit: 200
      t.string :password_digest, null: false
      t.string :name, null: false, limit: 100
      t.string :phone, limit: 20
      t.integer :role, null: false, default: 0       # enum: admin, manager, supervisor, worker, client
      t.integer :status, null: false, default: 0     # enum: active, inactive, pending, suspended
      t.string :avatar_url
      t.string :position, limit: 100
      t.string :department, limit: 100
      t.string :license_no, limit: 100
      t.datetime :last_login_at

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end

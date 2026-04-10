class CreateCostsAndBillings < ActiveRecord::Migration[8.1]
  def change
    create_table :costs do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.integer :category, null: false, default: 5  # other
      t.references :work_order, foreign_key: true
      t.references :subcontract, foreign_key: true
      t.text :description, null: false
      t.bigint :amount, null: false
      t.date :cost_date, null: false
      t.string :invoice_no, limit: 100
      t.integer :payment_status, null: false, default: 0  # pending
      t.date :paid_at
      t.references :recorded_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :costs, :cost_date

    create_table :billings do |t|
      t.string :billing_no, null: false, limit: 100
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.date :billing_month, null: false
      t.decimal :progress_rate, null: false, precision: 5, scale: 2
      t.bigint :claim_amount, null: false
      t.bigint :approved_amount
      t.integer :payment_status, null: false, default: 0  # pending
      t.date :submitted_at
      t.date :approved_at
      t.date :paid_at
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :billings, :billing_no, unique: true
  end
end

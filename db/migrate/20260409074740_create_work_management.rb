class CreateWorkManagement < ActiveRecord::Migration[8.1]
  def change
    create_table :work_categories do |t|
      t.references :parent, foreign_key: { to_table: :work_categories }
      t.string :name, null: false, limit: 200
      t.string :code, limit: 50
      t.text :description
      t.integer :sort_order, default: 0
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
    add_index :work_categories, :code, unique: true

    create_table :work_orders do |t|
      t.string :order_no, null: false, limit: 100
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :category, foreign_key: { to_table: :work_categories }
      t.string :title, null: false, limit: 300
      t.text :description
      t.string :location, limit: 300
      t.string :floor, limit: 50

      t.integer :status, null: false, default: 0     # draft
      t.integer :priority, null: false, default: 1    # medium

      t.date :planned_start
      t.date :planned_end
      t.date :actual_start
      t.date :actual_end

      t.decimal :estimated_hours, precision: 8, scale: 2
      t.decimal :actual_hours, precision: 8, scale: 2

      t.references :assigned_to, foreign_key: { to_table: :users }
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.datetime :approved_at

      t.references :subcontract, foreign_key: true
      t.references :parent_order, foreign_key: { to_table: :work_orders }

      t.timestamps
    end
    add_index :work_orders, :order_no, unique: true
    add_index :work_orders, :status
    add_index :work_orders, [:planned_start, :planned_end]

    create_table :daily_reports do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.date :report_date, null: false
      t.string :weather, limit: 50
      t.decimal :temperature, precision: 5, scale: 1
      t.text :work_summary
      t.text :progress_notes
      t.text :safety_notes
      t.text :special_notes
      t.integer :worker_count, default: 0
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.datetime :approved_at

      t.timestamps
    end
    add_index :daily_reports, [:project_id, :report_date, :created_by_id], unique: true, name: "idx_daily_reports_unique"

    create_table :daily_report_items do |t|
      t.references :report, null: false, foreign_key: { to_table: :daily_reports, on_delete: :cascade }
      t.references :work_order, foreign_key: true
      t.references :category, foreign_key: { to_table: :work_categories }
      t.text :description, null: false
      t.decimal :quantity, precision: 12, scale: 2
      t.string :unit, limit: 20
      t.integer :worker_count, default: 0
      t.decimal :progress_rate, precision: 5, scale: 2

      t.timestamps
    end
  end
end

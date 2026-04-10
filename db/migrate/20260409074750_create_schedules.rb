class CreateSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :schedules do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false, limit: 200
      t.integer :version, null: false, default: 1
      t.boolean :is_baseline, default: false
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    create_table :schedule_items do |t|
      t.references :schedule, null: false, foreign_key: { on_delete: :cascade }
      t.references :parent, foreign_key: { to_table: :schedule_items }
      t.references :work_order, foreign_key: true
      t.references :category, foreign_key: { to_table: :work_categories }
      t.string :wbs_code, limit: 100
      t.string :name, null: false, limit: 300
      t.integer :level, null: false, default: 1
      t.integer :sort_order, default: 0

      t.date :planned_start
      t.date :planned_end
      t.date :actual_start
      t.date :actual_end
      t.integer :duration_days

      t.integer :status, null: false, default: 0  # not_started
      t.decimal :progress_rate, precision: 5, scale: 2, default: 0
      t.decimal :weight, precision: 6, scale: 3, default: 0

      t.timestamps
    end
  end
end

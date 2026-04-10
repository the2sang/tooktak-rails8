class CreateWorkersAndAttendance < ActiveRecord::Migration[8.1]
  def change
    create_table :workers do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :name, null: false, limit: 100
      t.string :phone, limit: 20
      t.string :id_number, limit: 20
      t.string :trade, limit: 100
      t.string :skill_level, limit: 50
      t.string :license_no, limit: 100
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end

    create_table :attendances do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :worker, null: false, foreign_key: true
      t.date :work_date, null: false
      t.datetime :check_in
      t.datetime :check_out
      t.decimal :work_hours, precision: 5, scale: 2
      t.bigint :daily_wage
      t.string :work_type, limit: 50
      t.references :recorded_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :attendances, [:project_id, :worker_id, :work_date], unique: true, name: "idx_attendance_unique"
  end
end

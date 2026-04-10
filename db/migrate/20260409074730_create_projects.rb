class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :project_no, null: false, limit: 50
      t.string :name, null: false, limit: 300
      t.references :client_company, foreign_key: { to_table: :companies }
      t.references :contractor, foreign_key: { to_table: :companies }
      t.integer :project_type, null: false, default: 0
      t.integer :status, null: false, default: 0

      # 위치정보
      t.text :address
      t.decimal :latitude, precision: 10, scale: 8
      t.decimal :longitude, precision: 11, scale: 8
      t.decimal :site_area, precision: 12, scale: 2
      t.decimal :building_area, precision: 12, scale: 2
      t.decimal :total_floor_area, precision: 12, scale: 2
      t.integer :floors_above
      t.integer :floors_below

      # 일정
      t.date :contract_date
      t.date :start_date
      t.date :planned_end_date
      t.date :actual_end_date

      # 예산
      t.bigint :contract_amount
      t.bigint :budget_amount

      # 진행현황
      t.decimal :progress_rate, precision: 5, scale: 2, default: 0
      t.references :manager, foreign_key: { to_table: :users }
      t.text :description
      t.string :thumbnail_url

      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :projects, :project_no, unique: true
    add_index :projects, :status

    create_table :project_members do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.integer :role, null: false, default: 3  # worker
      t.date :joined_at, null: false, default: -> { "CURRENT_DATE" }
      t.date :left_at
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
    add_index :project_members, [:project_id, :user_id], unique: true

    create_table :subcontracts do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :subcontractor, null: false, foreign_key: { to_table: :companies }
      t.string :contract_no, limit: 100
      t.text :work_scope, null: false
      t.bigint :contract_amount, null: false
      t.date :start_date
      t.date :end_date
      t.integer :status, null: false, default: 2  # contracted
      t.references :manager, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

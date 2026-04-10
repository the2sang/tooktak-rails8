class CreateMaterials < ActiveRecord::Migration[8.1]
  def change
    create_table :materials do |t|
      t.string :code, limit: 100
      t.string :name, null: false, limit: 300
      t.string :category, limit: 100
      t.string :specification, limit: 300
      t.string :unit, null: false, limit: 20
      t.bigint :unit_price, default: 0
      t.references :supplier, foreign_key: { to_table: :companies }
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
    add_index :materials, :code, unique: true

    create_table :material_orders do |t|
      t.string :order_no, null: false, limit: 100
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :material, null: false, foreign_key: true
      t.references :supplier, foreign_key: { to_table: :companies }

      t.integer :status, null: false, default: 0  # planned

      t.decimal :planned_qty, null: false, precision: 12, scale: 2
      t.decimal :ordered_qty, precision: 12, scale: 2, default: 0
      t.decimal :delivered_qty, precision: 12, scale: 2, default: 0
      t.decimal :used_qty, precision: 12, scale: 2, default: 0

      t.bigint :unit_price
      t.bigint :total_amount

      t.date :planned_date
      t.date :order_date
      t.date :delivery_date

      t.references :work_order, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :material_orders, :order_no, unique: true
  end
end

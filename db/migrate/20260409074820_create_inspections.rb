class CreateInspections < ActiveRecord::Migration[8.1]
  def change
    create_table :inspection_templates do |t|
      t.string :name, null: false, limit: 200
      t.references :category, foreign_key: { to_table: :work_categories }
      t.text :description
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end

    create_table :inspection_template_items do |t|
      t.references :template, null: false, foreign_key: { to_table: :inspection_templates, on_delete: :cascade }
      t.integer :sort_order, null: false, default: 0
      t.text :item, null: false
      t.text :criteria

      t.timestamps
    end

    create_table :inspections do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :work_order, foreign_key: true
      t.references :template, foreign_key: { to_table: :inspection_templates }
      t.integer :inspection_type, null: false, default: 1  # in_progress
      t.integer :status, null: false, default: 0           # scheduled
      t.string :title, null: false, limit: 300
      t.string :location, limit: 300
      t.string :floor, limit: 50
      t.date :scheduled_date
      t.date :inspected_date
      t.references :inspector, foreign_key: { to_table: :users }
      t.text :result_notes
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :inspections, :status

    create_table :inspection_results do |t|
      t.references :inspection, null: false, foreign_key: { on_delete: :cascade }
      t.references :template_item, foreign_key: { to_table: :inspection_template_items }
      t.text :item, null: false
      t.boolean :is_passed
      t.text :notes

      t.timestamps
    end
  end
end

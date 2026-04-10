class CreateIssues < ActiveRecord::Migration[8.1]
  def change
    create_table :issues do |t|
      t.string :issue_no, null: false, limit: 100
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :work_order, foreign_key: true
      t.references :category, foreign_key: { to_table: :work_categories }
      t.string :title, null: false, limit: 300
      t.text :description
      t.string :location, limit: 300
      t.string :floor, limit: 50
      t.integer :status, null: false, default: 0     # open
      t.integer :severity, null: false, default: 2   # minor
      t.references :reported_by, foreign_key: { to_table: :users }
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.date :due_date
      t.datetime :resolved_at
      t.references :resolved_by, foreign_key: { to_table: :users }
      t.text :resolution

      t.timestamps
    end
    add_index :issues, :issue_no, unique: true
    add_index :issues, :status

    create_table :issue_comments do |t|
      t.references :issue, null: false, foreign_key: { on_delete: :cascade }
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.text :content, null: false

      t.timestamps
    end
  end
end

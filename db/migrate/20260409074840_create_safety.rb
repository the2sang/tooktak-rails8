class CreateSafety < ActiveRecord::Migration[8.1]
  def change
    create_table :safety_checks do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.date :check_date, null: false
      t.references :checker, foreign_key: { to_table: :users }
      t.string :overall_result, limit: 50
      t.text :notes

      t.timestamps
    end

    create_table :safety_check_items do |t|
      t.references :safety_check, null: false, foreign_key: { on_delete: :cascade }
      t.string :category, limit: 100
      t.text :item, null: false
      t.string :result, limit: 50
      t.text :notes

      t.timestamps
    end

    create_table :safety_trainings do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.date :training_date, null: false
      t.string :title, null: false, limit: 300
      t.text :content
      t.references :trainer, foreign_key: { to_table: :users }
      t.integer :duration_min

      t.timestamps
    end

    create_table :safety_training_attendees do |t|
      t.references :training, null: false, foreign_key: { to_table: :safety_trainings, on_delete: :cascade }
      t.references :worker, null: false, foreign_key: true
      t.datetime :signed_at

      t.timestamps
    end
    add_index :safety_training_attendees, [:training_id, :worker_id], unique: true, name: "idx_training_attendee_unique"
  end
end

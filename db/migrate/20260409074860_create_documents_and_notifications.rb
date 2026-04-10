class CreateDocumentsAndNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :work_order, foreign_key: true
      t.references :issue, foreign_key: true
      t.references :inspection, foreign_key: true
      t.integer :doc_type, null: false, default: 7    # other
      t.string :title, null: false, limit: 300
      t.text :description
      t.string :file_name, limit: 300
      t.string :file_url
      t.bigint :file_size
      t.string :mime_type, limit: 100
      t.integer :version, default: 1
      t.references :uploaded_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :documents, :doc_type

    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :project, foreign_key: true
      t.integer :notification_type, null: false, default: 0  # info
      t.string :title, null: false, limit: 300
      t.text :body
      t.string :link_type, limit: 50
      t.integer :link_id
      t.boolean :is_read, null: false, default: false
      t.datetime :read_at

      t.timestamps
    end
    add_index :notifications, [:user_id, :is_read], name: "idx_notifications_unread"

    create_table :audit_logs do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.string :table_name, null: false, limit: 100
      t.integer :record_id, null: false
      t.string :action, null: false, limit: 20
      t.json :old_values
      t.json :new_values
      t.string :ip_address, limit: 45

      t.timestamps
    end
    add_index :audit_logs, [:table_name, :record_id]
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_10_181646) do
  create_table "attendances", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.bigint "daily_wage"
    t.integer "project_id", null: false
    t.integer "recorded_by_id"
    t.datetime "updated_at", null: false
    t.date "work_date", null: false
    t.decimal "work_hours", precision: 5, scale: 2
    t.string "work_type", limit: 50
    t.integer "worker_id", null: false
    t.index ["project_id", "worker_id", "work_date"], name: "idx_attendance_unique", unique: true
    t.index ["project_id"], name: "index_attendances_on_project_id"
    t.index ["recorded_by_id"], name: "index_attendances_on_recorded_by_id"
    t.index ["worker_id"], name: "index_attendances_on_worker_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action", limit: 20, null: false
    t.datetime "created_at", null: false
    t.string "ip_address", limit: 45
    t.json "new_values"
    t.json "old_values"
    t.integer "project_id"
    t.integer "record_id", null: false
    t.string "table_name", limit: 100, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["project_id"], name: "index_audit_logs_on_project_id"
    t.index ["table_name", "record_id"], name: "index_audit_logs_on_table_name_and_record_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "billings", force: :cascade do |t|
    t.bigint "approved_amount"
    t.date "approved_at"
    t.date "billing_month", null: false
    t.string "billing_no", limit: 100, null: false
    t.bigint "claim_amount", null: false
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.date "paid_at"
    t.integer "payment_status", default: 0, null: false
    t.decimal "progress_rate", precision: 5, scale: 2, null: false
    t.integer "project_id", null: false
    t.date "submitted_at"
    t.datetime "updated_at", null: false
    t.index ["billing_no"], name: "index_billings_on_billing_no", unique: true
    t.index ["created_by_id"], name: "index_billings_on_created_by_id"
    t.index ["project_id"], name: "index_billings_on_project_id"
  end

  create_table "companies", force: :cascade do |t|
    t.text "address"
    t.string "business_no", limit: 20
    t.string "ceo_name", limit: 100
    t.integer "company_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "email", limit: 200
    t.boolean "is_active", default: true, null: false
    t.string "logo_url"
    t.string "name", limit: 200, null: false
    t.string "phone", limit: 20
    t.datetime "updated_at", null: false
    t.string "website", limit: 300
    t.index ["business_no"], name: "index_companies_on_business_no", unique: true
  end

  create_table "costs", force: :cascade do |t|
    t.bigint "amount", null: false
    t.integer "category", default: 5, null: false
    t.date "cost_date", null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "invoice_no", limit: 100
    t.date "paid_at"
    t.integer "payment_status", default: 0, null: false
    t.integer "project_id", null: false
    t.integer "recorded_by_id"
    t.integer "subcontract_id"
    t.datetime "updated_at", null: false
    t.integer "work_order_id"
    t.index ["cost_date"], name: "index_costs_on_cost_date"
    t.index ["project_id"], name: "index_costs_on_project_id"
    t.index ["recorded_by_id"], name: "index_costs_on_recorded_by_id"
    t.index ["subcontract_id"], name: "index_costs_on_subcontract_id"
    t.index ["work_order_id"], name: "index_costs_on_work_order_id"
  end

  create_table "daily_report_items", force: :cascade do |t|
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.decimal "progress_rate", precision: 5, scale: 2
    t.decimal "quantity", precision: 12, scale: 2
    t.integer "report_id", null: false
    t.string "unit", limit: 20
    t.datetime "updated_at", null: false
    t.integer "work_order_id"
    t.integer "worker_count", default: 0
    t.index ["category_id"], name: "index_daily_report_items_on_category_id"
    t.index ["report_id"], name: "index_daily_report_items_on_report_id"
    t.index ["work_order_id"], name: "index_daily_report_items_on_work_order_id"
  end

  create_table "daily_reports", force: :cascade do |t|
    t.datetime "approved_at"
    t.integer "approved_by_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id", null: false
    t.text "progress_notes"
    t.integer "project_id", null: false
    t.date "report_date", null: false
    t.text "safety_notes"
    t.text "special_notes"
    t.decimal "temperature", precision: 5, scale: 1
    t.datetime "updated_at", null: false
    t.string "weather", limit: 50
    t.text "work_summary"
    t.integer "worker_count", default: 0
    t.index ["approved_by_id"], name: "index_daily_reports_on_approved_by_id"
    t.index ["created_by_id"], name: "index_daily_reports_on_created_by_id"
    t.index ["project_id", "report_date", "created_by_id"], name: "idx_daily_reports_unique", unique: true
    t.index ["project_id"], name: "index_daily_reports_on_project_id"
  end

  create_table "documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "doc_type", default: 7, null: false
    t.string "file_name", limit: 300
    t.bigint "file_size"
    t.string "file_url"
    t.integer "inspection_id"
    t.integer "issue_id"
    t.string "mime_type", limit: 100
    t.integer "project_id", null: false
    t.string "title", limit: 300, null: false
    t.datetime "updated_at", null: false
    t.integer "uploaded_by_id"
    t.integer "version", default: 1
    t.integer "work_order_id"
    t.index ["doc_type"], name: "index_documents_on_doc_type"
    t.index ["inspection_id"], name: "index_documents_on_inspection_id"
    t.index ["issue_id"], name: "index_documents_on_issue_id"
    t.index ["project_id"], name: "index_documents_on_project_id"
    t.index ["uploaded_by_id"], name: "index_documents_on_uploaded_by_id"
    t.index ["work_order_id"], name: "index_documents_on_work_order_id"
  end

  create_table "inspection_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "inspection_id", null: false
    t.boolean "is_passed"
    t.text "item", null: false
    t.text "notes"
    t.integer "template_item_id"
    t.datetime "updated_at", null: false
    t.index ["inspection_id"], name: "index_inspection_results_on_inspection_id"
    t.index ["template_item_id"], name: "index_inspection_results_on_template_item_id"
  end

  create_table "inspection_template_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "criteria"
    t.text "item", null: false
    t.integer "sort_order", default: 0, null: false
    t.integer "template_id", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_inspection_template_items_on_template_id"
  end

  create_table "inspection_templates", force: :cascade do |t|
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_active", default: true, null: false
    t.string "name", limit: 200, null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_inspection_templates_on_category_id"
  end

  create_table "inspections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.string "floor", limit: 50
    t.date "inspected_date"
    t.integer "inspection_type", default: 1, null: false
    t.integer "inspector_id"
    t.string "location", limit: 300
    t.integer "project_id", null: false
    t.text "result_notes"
    t.date "scheduled_date"
    t.integer "status", default: 0, null: false
    t.integer "template_id"
    t.string "title", limit: 300, null: false
    t.datetime "updated_at", null: false
    t.integer "work_order_id"
    t.index ["created_by_id"], name: "index_inspections_on_created_by_id"
    t.index ["inspector_id"], name: "index_inspections_on_inspector_id"
    t.index ["project_id"], name: "index_inspections_on_project_id"
    t.index ["status"], name: "index_inspections_on_status"
    t.index ["template_id"], name: "index_inspections_on_template_id"
    t.index ["work_order_id"], name: "index_inspections_on_work_order_id"
  end

  create_table "issue_comments", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "issue_id", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_issue_comments_on_author_id"
    t.index ["issue_id"], name: "index_issue_comments_on_issue_id"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "assigned_to_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.string "floor", limit: 50
    t.string "issue_no", limit: 100, null: false
    t.string "location", limit: 300
    t.integer "project_id", null: false
    t.integer "reported_by_id"
    t.text "resolution"
    t.datetime "resolved_at"
    t.integer "resolved_by_id"
    t.integer "severity", default: 2, null: false
    t.integer "status", default: 0, null: false
    t.string "title", limit: 300, null: false
    t.datetime "updated_at", null: false
    t.integer "work_order_id"
    t.index ["assigned_to_id"], name: "index_issues_on_assigned_to_id"
    t.index ["category_id"], name: "index_issues_on_category_id"
    t.index ["issue_no"], name: "index_issues_on_issue_no", unique: true
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["reported_by_id"], name: "index_issues_on_reported_by_id"
    t.index ["resolved_by_id"], name: "index_issues_on_resolved_by_id"
    t.index ["status"], name: "index_issues_on_status"
    t.index ["work_order_id"], name: "index_issues_on_work_order_id"
  end

  create_table "material_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.decimal "delivered_qty", precision: 12, scale: 2, default: "0.0"
    t.date "delivery_date"
    t.integer "material_id", null: false
    t.date "order_date"
    t.string "order_no", limit: 100, null: false
    t.decimal "ordered_qty", precision: 12, scale: 2, default: "0.0"
    t.date "planned_date"
    t.decimal "planned_qty", precision: 12, scale: 2, null: false
    t.integer "project_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "supplier_id"
    t.bigint "total_amount"
    t.bigint "unit_price"
    t.datetime "updated_at", null: false
    t.decimal "used_qty", precision: 12, scale: 2, default: "0.0"
    t.integer "work_order_id"
    t.index ["created_by_id"], name: "index_material_orders_on_created_by_id"
    t.index ["material_id"], name: "index_material_orders_on_material_id"
    t.index ["order_no"], name: "index_material_orders_on_order_no", unique: true
    t.index ["project_id"], name: "index_material_orders_on_project_id"
    t.index ["supplier_id"], name: "index_material_orders_on_supplier_id"
    t.index ["work_order_id"], name: "index_material_orders_on_work_order_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "category", limit: 100
    t.string "code", limit: 100
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "name", limit: 300, null: false
    t.string "specification", limit: 300
    t.integer "supplier_id"
    t.string "unit", limit: 20, null: false
    t.bigint "unit_price", default: 0
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_materials_on_code", unique: true
    t.index ["supplier_id"], name: "index_materials_on_supplier_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.boolean "is_read", default: false, null: false
    t.integer "link_id"
    t.string "link_type", limit: 50
    t.integer "notification_type", default: 0, null: false
    t.integer "project_id"
    t.datetime "read_at"
    t.string "title", limit: 300, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["project_id"], name: "index_notifications_on_project_id"
    t.index ["user_id", "is_read"], name: "idx_notifications_unread"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "project_members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.date "joined_at", default: -> { "CURRENT_DATE" }, null: false
    t.date "left_at"
    t.integer "project_id", null: false
    t.integer "role", default: 3, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_project_members_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_project_members_on_project_id"
    t.index ["user_id"], name: "index_project_members_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.date "actual_end_date"
    t.text "address"
    t.bigint "budget_amount"
    t.decimal "building_area", precision: 12, scale: 2
    t.integer "client_company_id"
    t.bigint "contract_amount"
    t.date "contract_date"
    t.integer "contractor_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "description"
    t.integer "floors_above"
    t.integer "floors_below"
    t.decimal "latitude", precision: 10, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.integer "manager_id"
    t.string "name", limit: 300, null: false
    t.date "planned_end_date"
    t.decimal "progress_rate", precision: 5, scale: 2, default: "0.0"
    t.string "project_no", limit: 50, null: false
    t.integer "project_type", default: 0, null: false
    t.decimal "site_area", precision: 12, scale: 2
    t.date "start_date"
    t.integer "status", default: 0, null: false
    t.string "thumbnail_url"
    t.decimal "total_floor_area", precision: 12, scale: 2
    t.datetime "updated_at", null: false
    t.index ["client_company_id"], name: "index_projects_on_client_company_id"
    t.index ["contractor_id"], name: "index_projects_on_contractor_id"
    t.index ["created_by_id"], name: "index_projects_on_created_by_id"
    t.index ["manager_id"], name: "index_projects_on_manager_id"
    t.index ["project_no"], name: "index_projects_on_project_no", unique: true
    t.index ["status"], name: "index_projects_on_status"
  end

  create_table "safety_check_items", force: :cascade do |t|
    t.string "category", limit: 100
    t.datetime "created_at", null: false
    t.text "item", null: false
    t.text "notes"
    t.string "result", limit: 50
    t.integer "safety_check_id", null: false
    t.datetime "updated_at", null: false
    t.index ["safety_check_id"], name: "index_safety_check_items_on_safety_check_id"
  end

  create_table "safety_checks", force: :cascade do |t|
    t.date "check_date", null: false
    t.integer "checker_id"
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "overall_result", limit: 50
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["checker_id"], name: "index_safety_checks_on_checker_id"
    t.index ["project_id"], name: "index_safety_checks_on_project_id"
  end

  create_table "safety_training_attendees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "signed_at"
    t.integer "training_id", null: false
    t.datetime "updated_at", null: false
    t.integer "worker_id", null: false
    t.index ["training_id", "worker_id"], name: "idx_training_attendee_unique", unique: true
    t.index ["training_id"], name: "index_safety_training_attendees_on_training_id"
    t.index ["worker_id"], name: "index_safety_training_attendees_on_worker_id"
  end

  create_table "safety_trainings", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "duration_min"
    t.integer "project_id", null: false
    t.string "title", limit: 300, null: false
    t.integer "trainer_id"
    t.date "training_date", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_safety_trainings_on_project_id"
    t.index ["trainer_id"], name: "index_safety_trainings_on_trainer_id"
  end

  create_table "schedule_items", force: :cascade do |t|
    t.date "actual_end"
    t.date "actual_start"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.integer "duration_days"
    t.integer "level", default: 1, null: false
    t.string "name", limit: 300, null: false
    t.integer "parent_id"
    t.date "planned_end"
    t.date "planned_start"
    t.decimal "progress_rate", precision: 5, scale: 2, default: "0.0"
    t.integer "schedule_id", null: false
    t.integer "sort_order", default: 0
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "wbs_code", limit: 100
    t.decimal "weight", precision: 6, scale: 3, default: "0.0"
    t.integer "work_order_id"
    t.index ["category_id"], name: "index_schedule_items_on_category_id"
    t.index ["parent_id"], name: "index_schedule_items_on_parent_id"
    t.index ["schedule_id"], name: "index_schedule_items_on_schedule_id"
    t.index ["work_order_id"], name: "index_schedule_items_on_work_order_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.boolean "is_baseline", default: false
    t.string "name", limit: 200, null: false
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
    t.integer "version", default: 1, null: false
    t.index ["created_by_id"], name: "index_schedules_on_created_by_id"
    t.index ["project_id"], name: "index_schedules_on_project_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subcontracts", force: :cascade do |t|
    t.bigint "contract_amount", null: false
    t.string "contract_no", limit: 100
    t.datetime "created_at", null: false
    t.date "end_date"
    t.integer "manager_id"
    t.integer "project_id", null: false
    t.date "start_date"
    t.integer "status", default: 2, null: false
    t.integer "subcontractor_id", null: false
    t.datetime "updated_at", null: false
    t.text "work_scope", null: false
    t.index ["manager_id"], name: "index_subcontracts_on_manager_id"
    t.index ["project_id"], name: "index_subcontracts_on_project_id"
    t.index ["subcontractor_id"], name: "index_subcontracts_on_subcontractor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.string "avatar_url_oauth"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.string "department", limit: 100
    t.string "email_address", limit: 200, null: false
    t.datetime "last_login_at"
    t.string "license_no", limit: 100
    t.string "name", limit: 100, null: false
    t.string "password_digest"
    t.string "phone", limit: 20
    t.string "position", limit: 100
    t.string "provider"
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "work_categories", force: :cascade do |t|
    t.string "code", limit: 50
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_active", default: true, null: false
    t.string "name", limit: 200, null: false
    t.integer "parent_id"
    t.integer "sort_order", default: 0
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_work_categories_on_code", unique: true
    t.index ["parent_id"], name: "index_work_categories_on_parent_id"
  end

  create_table "work_orders", force: :cascade do |t|
    t.date "actual_end"
    t.decimal "actual_hours", precision: 8, scale: 2
    t.date "actual_start"
    t.datetime "approved_at"
    t.integer "approved_by_id"
    t.integer "assigned_to_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "description"
    t.decimal "estimated_hours", precision: 8, scale: 2
    t.string "floor", limit: 50
    t.string "location", limit: 300
    t.string "order_no", limit: 100, null: false
    t.integer "parent_order_id"
    t.date "planned_end"
    t.date "planned_start"
    t.integer "priority", default: 1, null: false
    t.integer "project_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "subcontract_id"
    t.string "title", limit: 300, null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_work_orders_on_approved_by_id"
    t.index ["assigned_to_id"], name: "index_work_orders_on_assigned_to_id"
    t.index ["category_id"], name: "index_work_orders_on_category_id"
    t.index ["created_by_id"], name: "index_work_orders_on_created_by_id"
    t.index ["order_no"], name: "index_work_orders_on_order_no", unique: true
    t.index ["parent_order_id"], name: "index_work_orders_on_parent_order_id"
    t.index ["planned_start", "planned_end"], name: "index_work_orders_on_planned_start_and_planned_end"
    t.index ["project_id"], name: "index_work_orders_on_project_id"
    t.index ["status"], name: "index_work_orders_on_status"
    t.index ["subcontract_id"], name: "index_work_orders_on_subcontract_id"
  end

  create_table "workers", force: :cascade do |t|
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.string "id_number", limit: 20
    t.boolean "is_active", default: true, null: false
    t.string "license_no", limit: 100
    t.string "name", limit: 100, null: false
    t.string "phone", limit: 20
    t.string "skill_level", limit: 50
    t.string "trade", limit: 100
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["company_id"], name: "index_workers_on_company_id"
    t.index ["user_id"], name: "index_workers_on_user_id"
  end

  add_foreign_key "attendances", "projects", on_delete: :cascade
  add_foreign_key "attendances", "users", column: "recorded_by_id"
  add_foreign_key "attendances", "workers"
  add_foreign_key "audit_logs", "projects"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "billings", "projects", on_delete: :cascade
  add_foreign_key "billings", "users", column: "created_by_id"
  add_foreign_key "costs", "projects", on_delete: :cascade
  add_foreign_key "costs", "subcontracts"
  add_foreign_key "costs", "users", column: "recorded_by_id"
  add_foreign_key "costs", "work_orders"
  add_foreign_key "daily_report_items", "daily_reports", column: "report_id", on_delete: :cascade
  add_foreign_key "daily_report_items", "work_categories", column: "category_id"
  add_foreign_key "daily_report_items", "work_orders"
  add_foreign_key "daily_reports", "projects", on_delete: :cascade
  add_foreign_key "daily_reports", "users", column: "approved_by_id"
  add_foreign_key "daily_reports", "users", column: "created_by_id"
  add_foreign_key "documents", "inspections"
  add_foreign_key "documents", "issues"
  add_foreign_key "documents", "projects", on_delete: :cascade
  add_foreign_key "documents", "users", column: "uploaded_by_id"
  add_foreign_key "documents", "work_orders"
  add_foreign_key "inspection_results", "inspection_template_items", column: "template_item_id"
  add_foreign_key "inspection_results", "inspections", on_delete: :cascade
  add_foreign_key "inspection_template_items", "inspection_templates", column: "template_id", on_delete: :cascade
  add_foreign_key "inspection_templates", "work_categories", column: "category_id"
  add_foreign_key "inspections", "inspection_templates", column: "template_id"
  add_foreign_key "inspections", "projects", on_delete: :cascade
  add_foreign_key "inspections", "users", column: "created_by_id"
  add_foreign_key "inspections", "users", column: "inspector_id"
  add_foreign_key "inspections", "work_orders"
  add_foreign_key "issue_comments", "issues", on_delete: :cascade
  add_foreign_key "issue_comments", "users", column: "author_id"
  add_foreign_key "issues", "projects", on_delete: :cascade
  add_foreign_key "issues", "users", column: "assigned_to_id"
  add_foreign_key "issues", "users", column: "reported_by_id"
  add_foreign_key "issues", "users", column: "resolved_by_id"
  add_foreign_key "issues", "work_categories", column: "category_id"
  add_foreign_key "issues", "work_orders"
  add_foreign_key "material_orders", "companies", column: "supplier_id"
  add_foreign_key "material_orders", "materials"
  add_foreign_key "material_orders", "projects", on_delete: :cascade
  add_foreign_key "material_orders", "users", column: "created_by_id"
  add_foreign_key "material_orders", "work_orders"
  add_foreign_key "materials", "companies", column: "supplier_id"
  add_foreign_key "notifications", "projects"
  add_foreign_key "notifications", "users", on_delete: :cascade
  add_foreign_key "project_members", "projects", on_delete: :cascade
  add_foreign_key "project_members", "users", on_delete: :cascade
  add_foreign_key "projects", "companies", column: "client_company_id"
  add_foreign_key "projects", "companies", column: "contractor_id"
  add_foreign_key "projects", "users", column: "created_by_id"
  add_foreign_key "projects", "users", column: "manager_id"
  add_foreign_key "safety_check_items", "safety_checks", on_delete: :cascade
  add_foreign_key "safety_checks", "projects", on_delete: :cascade
  add_foreign_key "safety_checks", "users", column: "checker_id"
  add_foreign_key "safety_training_attendees", "safety_trainings", column: "training_id", on_delete: :cascade
  add_foreign_key "safety_training_attendees", "workers"
  add_foreign_key "safety_trainings", "projects", on_delete: :cascade
  add_foreign_key "safety_trainings", "users", column: "trainer_id"
  add_foreign_key "schedule_items", "schedule_items", column: "parent_id"
  add_foreign_key "schedule_items", "schedules", on_delete: :cascade
  add_foreign_key "schedule_items", "work_categories", column: "category_id"
  add_foreign_key "schedule_items", "work_orders"
  add_foreign_key "schedules", "projects", on_delete: :cascade
  add_foreign_key "schedules", "users", column: "created_by_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "subcontracts", "companies", column: "subcontractor_id"
  add_foreign_key "subcontracts", "projects", on_delete: :cascade
  add_foreign_key "subcontracts", "users", column: "manager_id"
  add_foreign_key "users", "companies"
  add_foreign_key "work_categories", "work_categories", column: "parent_id"
  add_foreign_key "work_orders", "projects", on_delete: :cascade
  add_foreign_key "work_orders", "subcontracts"
  add_foreign_key "work_orders", "users", column: "approved_by_id"
  add_foreign_key "work_orders", "users", column: "assigned_to_id"
  add_foreign_key "work_orders", "users", column: "created_by_id"
  add_foreign_key "work_orders", "work_categories", column: "category_id"
  add_foreign_key "work_orders", "work_orders", column: "parent_order_id"
  add_foreign_key "workers", "companies"
  add_foreign_key "workers", "users"
end

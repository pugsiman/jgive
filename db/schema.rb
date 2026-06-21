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

ActiveRecord::Schema[8.0].define(version: 2026_06_21_140120) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "donation_state", ["pending", "paid"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "campaign_donation_stats", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.string "user_email", null: false
    t.bigint "amount_cents", default: 0, null: false
    t.integer "donations_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "user_email"], name: "index_campaign_donation_stats_on_campaign_id_and_user_email", unique: true
    t.index ["campaign_id"], name: "index_campaign_donation_stats_on_campaign_id"
    t.check_constraint "amount_cents >= 0", name: "campaign_donation_stats_amount_nonnegative"
    t.check_constraint "donations_count >= 0", name: "campaign_donation_stats_count_nonnegative"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title", null: false
    t.text "story", null: false
    t.bigint "goal_amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "goal_amount_cents > 0", name: "campaigns_goal_amount_cents_positive"
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "amount_cents", null: false
    t.string "giving_frequency", default: "one_time", null: false
    t.string "donor_display_preference", default: "full_name", null: false
    t.text "dedication_message"
    t.string "user_email", null: false
    t.enum "state", default: "pending", null: false, enum_type: "donation_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "donor_first_name"
    t.string "donor_last_name"
    t.index "lower((user_email)::text)", name: "index_donations_on_lower_user_email"
    t.index ["campaign_id", "state"], name: "index_donations_on_campaign_id_and_state"
    t.index ["campaign_id", "user_email"], name: "index_donations_on_campaign_id_and_user_email"
    t.index ["campaign_id"], name: "index_donations_on_campaign_id"
    t.check_constraint "amount_cents > 0", name: "donations_amount_cents_positive"
    t.check_constraint "donor_display_preference::text = ANY (ARRAY['full_name'::character varying::text, 'first_name_only'::character varying::text, 'anonymous'::character varying::text])", name: "donations_donor_display_preference_valid"
    t.check_constraint "giving_frequency::text = ANY (ARRAY['one_time'::character varying::text, 'recurring'::character varying::text])", name: "donations_giving_frequency_valid"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaign_donation_stats", "campaigns"
  add_foreign_key "donations", "campaigns"
end

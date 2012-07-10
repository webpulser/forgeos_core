# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111116212547) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "forgeos_addresses", :force => true do |t|
    t.string   "address"
    t.string   "address_2"
    t.string   "zip_code"
    t.string   "city"
    t.string   "type"
    t.integer  "country_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forgeos_attachment_links", :force => true do |t|
    t.integer "attachment_id"
    t.integer "element_id"
    t.integer "position"
    t.string  "element_type"
    t.string  "attachment_type"
  end

  create_table "forgeos_attachments", :force => true do |t|
    t.string   "name"
    t.string   "file"
    t.string   "file_content_type"
    t.string   "file_width"
    t.string   "file_height"
    t.string   "file_image_size"
    t.string   "file_size"
    t.string   "file_tmp"
    t.boolean   "file_processing"
    t.string   "type"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "alt"
  end

  create_table "forgeos_categories", :force => true do |t|
    t.string   "type",       :limit => 45
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                 :default => 0
  end

  add_index "forgeos_categories", ["id", "type"], :name => "index_forgeos_categories_on_id_and_type", :unique => true

  create_table "forgeos_categories_elements", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "element_id"
    t.integer "position",    :default => 0, :null => false
  end

  add_index "forgeos_categories_elements", ["category_id", "element_id"], :name => "index_forgeos_categories_elements_on_category_id_and_element_id", :unique => true

  create_table "forgeos_category_translations", :force => true do |t|
    t.integer  "forgeos_category_id"
    t.string   "locale"
    t.string   "url"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forgeos_category_translations", ["forgeos_category_id"], :name => "index_cc5c2f78ec5fe2953ff591ce10708766eaa1c94e"

  create_table "forgeos_comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forgeos_comments", ["person_id"], :name => "fk_comments_person"

  create_table "forgeos_geo_zones", :force => true do |t|
    t.string  "iso"
    t.string  "iso3"
    t.string  "name"
    t.string  "printable_name"
    t.string  "type"
    t.integer "numcode"
    t.integer "parent_id"
  end

  create_table "forgeos_import_sets", :force => true do |t|
    t.text     "fields"
    t.text     "parser_options"
    t.boolean  "ignore_first_row", :default => true, :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forgeos_meta_info_translations", :force => true do |t|
    t.integer  "forgeos_meta_info_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forgeos_meta_info_translations", ["forgeos_meta_info_id"], :name => "index_bf657d8aeb1f08a77976f6aca7e82e1ff66a07ee"

  create_table "forgeos_meta_infos", :force => true do |t|
    t.integer "target_id"
    t.string  "target_type"
  end

  create_table "forgeos_people", :force => true do |t|
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "type"
    t.string   "phone"
    t.string   "other_phone"
    t.string   "lang"
    t.string   "time_zone"
    t.string   "crypted_password",   :limit => 128
    t.string   "password_salt",      :limit => 128
    t.integer  "avatar_id"
    t.integer  "country_id"
    t.integer  "role_id"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "civility"
    t.string   "persistence_token",                 :default => "",    :null => false
    t.string   "perishable_token",                  :default => "",    :null => false
    t.integer  "login_count",                       :default => 0,     :null => false
    t.integer  "failed_login_count",                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "active",                            :default => false, :null => false
    t.boolean  "delta",                             :default => true,  :null => false
  end

  create_table "forgeos_rights", :force => true do |t|
    t.string "name"
    t.string "controller_name"
    t.string "action_name"
  end

  create_table "forgeos_roles", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forgeos_rules", :force => true do |t|
    t.text    "conditions"
    t.text    "description"
    t.text    "variables"
    t.integer "use",         :default => 0,    :null => false
    t.integer "max_use",     :default => 0,    :null => false
    t.string  "name"
    t.string  "type"
    t.string  "code"
    t.boolean "active",      :default => true, :null => false
    t.integer "parent_id"
  end

  create_table "forgeos_search_keywords", :force => true do |t|
    t.string   "keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forgeos_settings", :force => true do |t|
    t.string  "name"
    t.string  "lang"
    t.string  "time_zone"
    t.string  "phone_number"
    t.string  "fax_number"
    t.string  "email"
    t.text    "mailer",            :null => false, :default => ''
    t.text    "smtp_settings",     :null => false, :default => ''
    t.text    "sendmail_settings", :null => false, :default => ''
    t.integer "address_id"
    t.text    "attachments"
  end

  create_table "forgeos_statistic_counters", :force => true do |t|
    t.string  "type"
    t.date    "date"
    t.integer "counter",      :default => 1
    t.integer "element_id"
    t.string  "element_type"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end

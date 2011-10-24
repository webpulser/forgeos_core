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

ActiveRecord::Schema.define(:version => 20111024101878) do

  create_table "addresses", :force => true do |t|
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

  create_table "attachment_links", :force => true do |t|
    t.integer "attachment_id"
    t.integer "element_id"
    t.integer "position"
    t.string  "element_type"
    t.string  "attachment_type"
  end

  create_table "attachments", :force => true do |t|
    t.string   "content_type"
    t.string   "name"
    t.string   "filename"
    t.string   "alternative"
    t.string   "thumbnail"
    t.string   "type"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "alt"
  end

  create_table "categories", :force => true do |t|
    t.string   "type",       :limit => 45
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                 :default => 0
  end

  add_index "categories", ["id", "type"], :name => "index_categories_on_id_and_type", :unique => true

  create_table "categories_elements", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "element_id"
    t.integer "position",    :default => 0, :null => false
  end

  add_index "categories_elements", ["category_id", "element_id"], :name => "index_categories_elements_on_category_id_and_element_id", :unique => true

  create_table "category_translations", :force => true do |t|
    t.integer  "category_id"
    t.string   "locale"
    t.string   "url"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_translations", ["category_id"], :name => "index_category_translations_on_category_id"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["person_id"], :name => "fk_comments_person"

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

  create_table "geo_zones", :force => true do |t|
    t.string  "iso"
    t.string  "iso3"
    t.string  "name"
    t.string  "printable_name"
    t.string  "type"
    t.integer "numcode"
    t.integer "parent_id"
  end

  create_table "import_sets", :force => true do |t|
    t.text     "fields"
    t.text     "parser_options"
    t.boolean  "ignore_first_row", :default => true, :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_info_translations", :force => true do |t|
    t.integer  "meta_info_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meta_info_translations", ["meta_info_id"], :name => "index_meta_info_translations_on_meta_info_id"

  create_table "meta_infos", :force => true do |t|
    t.integer "target_id"
    t.string  "target_type"
  end

  create_table "people", :force => true do |t|
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
    t.string   "people",                            :default => ""
    t.string   "perishable_token",                  :default => ""
    t.string   "string",                            :default => ""
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

  create_table "rights", :force => true do |t|
    t.string "name"
    t.string "controller_name"
    t.string "action_name"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
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

  create_table "search_keywords", :force => true do |t|
    t.string   "keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string  "name"
    t.string  "lang"
    t.string  "time_zone"
    t.string  "phone_number"
    t.string  "fax_number"
    t.string  "email"
    t.text    "mailer",            :null => false
    t.text    "smtp_settings",     :null => false
    t.text    "sendmail_settings", :null => false
    t.integer "address_id"
    t.text    "attachments"
  end

  create_table "statistic_counters", :force => true do |t|
    t.string  "type"
    t.date    "date"
    t.integer "counter",      :default => 1
    t.integer "element_id"
    t.string  "element_type"
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

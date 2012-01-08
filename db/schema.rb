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

ActiveRecord::Schema.define(:version => 20110526215404) do

  create_table "coders", :force => true do |t|
    t.integer  "org_id"
    t.string   "gravatar_id"
    t.string   "company"
    t.string   "name"
    t.datetime "created_at"
    t.string   "location"
    t.integer  "public_repo_count"
    t.integer  "public_gist_count"
    t.string   "blog"
    t.integer  "following_count"
    t.string   "type"
    t.integer  "followers_count"
    t.string   "login"
    t.boolean  "permission"
    t.string   "email"
    t.datetime "first_commit"
  end

  add_index "coders", ["created_at"], :name => "index_coders_on_created_at"
  add_index "coders", ["followers_count"], :name => "index_coders_on_followers_count"
  add_index "coders", ["following_count"], :name => "index_coders_on_following_count"
  add_index "coders", ["login"], :name => "index_coders_on_login"
  add_index "coders", ["org_id"], :name => "index_coders_on_org_id"
  add_index "coders", ["public_gist_count"], :name => "index_coders_on_public_gist_count"
  add_index "coders", ["public_repo_count"], :name => "index_coders_on_public_repo_count"

  create_table "commits", :force => true do |t|
    t.integer  "project_id"
    t.integer  "coder_id"
    t.integer  "org_id"
    t.string   "sha"
    t.string   "branch"
    t.string   "message"
    t.datetime "committed_date"
  end

  add_index "commits", ["coder_id"], :name => "index_commits_on_coder_id"
  add_index "commits", ["committed_date"], :name => "index_commits_on_committed_date"
  add_index "commits", ["org_id"], :name => "index_commits_on_org_id"
  add_index "commits", ["project_id"], :name => "index_commits_on_project_id"
  add_index "commits", ["sha"], :name => "index_commits_on_sha"

  create_table "counters", :force => true do |t|
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counters", ["project_id"], :name => "index_counters_on_project_id"

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

  create_table "orgs", :force => true do |t|
    t.string   "gravatar_id"
    t.string   "company"
    t.string   "name"
    t.datetime "created_at"
    t.string   "location"
    t.integer  "public_repo_count"
    t.integer  "public_gist_count"
    t.boolean  "permission"
    t.string   "blog"
    t.integer  "following_count"
    t.string   "type"
    t.integer  "followers_count"
    t.string   "login"
    t.string   "email"
  end

  add_index "orgs", ["created_at"], :name => "index_orgs_on_created_at"
  add_index "orgs", ["email"], :name => "index_orgs_on_email"
  add_index "orgs", ["followers_count"], :name => "index_orgs_on_followers_count"
  add_index "orgs", ["following_count"], :name => "index_orgs_on_following_count"
  add_index "orgs", ["id"], :name => "index_orgs_on_id"
  add_index "orgs", ["login"], :name => "index_orgs_on_login"

  create_table "projects", :force => true do |t|
    t.string   "homepage"
    t.string   "has_downloads"
    t.integer  "forks"
    t.string   "url"
    t.integer  "watchers"
    t.string   "has_wiki"
    t.boolean  "fork"
    t.string   "language"
    t.integer  "open_issues"
    t.datetime "created_at"
    t.string   "organization"
    t.text     "description"
    t.integer  "size"
    t.boolean  "private"
    t.boolean  "has_issues"
    t.datetime "pushed_at"
    t.string   "name"
    t.boolean  "permission"
    t.string   "owner"
    t.integer  "org_id"
  end

  add_index "projects", ["created_at"], :name => "index_projects_on_created_at"
  add_index "projects", ["fork"], :name => "index_projects_on_fork"
  add_index "projects", ["forks"], :name => "index_projects_on_forks"
  add_index "projects", ["name"], :name => "index_projects_on_name"
  add_index "projects", ["open_issues"], :name => "index_projects_on_open_issues"
  add_index "projects", ["org_id"], :name => "index_projects_on_org_id"
  add_index "projects", ["organization"], :name => "index_projects_on_organization"
  add_index "projects", ["size"], :name => "index_projects_on_size"
  add_index "projects", ["watchers"], :name => "index_projects_on_watchers"

end

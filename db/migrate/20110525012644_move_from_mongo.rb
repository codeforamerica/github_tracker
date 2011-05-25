class MoveFromMongo < ActiveRecord::Migration
  def self.up
    create_table :coders do |t|
      t.integer :org_id 
      t.string :gravatar_id 
      t.string :company
      t.string :name
      t.datetime :created_at
      t.string :location
      t.integer :public_repo_count
      t.integer :public_gist_count
      t.string :blog
      t.integer :following_count
      t.string :type
      t.integer :followers_count
      t.string :login
      t.boolean :permission
      t.string :email
    end

    add_index :coders, :org_id
    add_index :coders, :login
    add_index :coders, :following_count
    add_index :coders, :followers_count
    add_index :coders, :public_repo_count  
    add_index :coders, :public_gist_count    
    add_index :coders, :created_at
    
    create_table :commits do |t|
      t.integer :project_id
      t.integer :coder_id
      t.integer :org_id
      t.string :sha
      t.string :branch
      t.string :message
      t.datetime :committed_date
    end
    
    add_index :commits, :sha
    add_index :commits, :project_id
    add_index :commits, :coder_id
    add_index :commits, :org_id
    add_index :commits, :committed_date
    
    create_table :orgs do |t|
      t.string :gravatar_id
      t.string :company
      t.string :name
      t.datetime :created_at
      t.string :location
      t.integer :public_repo_count
      t.integer :public_gist_count
      t.boolean :permission
      t.string :blog
      t.integer :following_count
      t.string :type
      t.integer :followers_count
      t.string :login 
      t.string :email 
    end
    
    add_index :orgs, :id
    add_index :orgs, :login
    add_index :orgs, :email
    add_index :orgs, :followers_count
    add_index :orgs, :following_count
    add_index :orgs, :created_at
    
    create_table :projects do |t|
      t.string :homepage 
      t.string :has_downloads
      t.integer :forks
      t.string :url 
      t.integer :watchers
      t.string :has_wiki
      t.boolean :fork
      t.string :language
      t.integer :open_issues
      t.datetime :created_at
      t.string :organization
      t.text :description
      t.integer :size
      t.boolean :private
      t.boolean :has_issues
      t.datetime :pushed_at
      t.string :name
      t.boolean :permission      
      t.string :owner
      t.integer :org_id
    end
    
    add_index :projects, :name
    add_index :projects, :org_id
    add_index :projects, :organization
    add_index :projects, :fork
    add_index :projects, :forks  
    add_index :projects, :open_issues
    add_index :projects, :created_at
    add_index :projects, :size
    add_index :projects, :watchers
    
  end

  def self.down
    drop_table :projects
    drop_table :orgs
    drop_table :coders
    drop_table :commits   
  end
end

class Commit 
  include Mongoid::Document
  referenced_in :project
  referenced_in :coder  
  
  field :id
  field :project_id
  field :coder_id
  field :sha
  field :branch
  field :message
  field :committed_date
  
  index :id
  index :sha
  index :project_id
  index :coder_id
  index :committed_date
  
  validates_uniqueness_of :sha
  
  def find_or_create(options={})
    commit = Commit.where(:sha => options[:sha]).first
    !commit.blank? ? commit : Commit.create!(options)
  end
    
end
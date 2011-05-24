class Commit 
  include Mongoid::Document
  referenced_in :project
  referenced_in :coder  
  
  validates_uniqueness_of :sha
  
  def find_or_create(options={})
    commit = Commit.where(:sha => options[:sha]).first
    !commit.blank? ? commit : Commit.create!(options)
  end
    
end
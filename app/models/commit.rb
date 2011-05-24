class Commit 
  include Mongoid::Document
  referenced_in :project
  referenced_in :coder  
  
  validates_uniqueness_of :sha
    
end
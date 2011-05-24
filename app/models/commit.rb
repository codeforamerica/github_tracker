class Commit 
  include Mongoid::Document
  embedded_in :project, :inverse_of => :commits 
  referenced_in :project  
end
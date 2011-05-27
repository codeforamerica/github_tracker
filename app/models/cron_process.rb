class CronProcess
  # cleans up projects with no commits
  def clean_projects
    Project.all.each { |x| if x.commits.blank? then x.delete end}    
  end
  
  # cleans up coders with no commits
  def clean_coders
    Coder.all.each { |x| if x.commits.blank? then x.delete end}    
  end
  
end
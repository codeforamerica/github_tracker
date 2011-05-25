class DashboardController < ApplicationController
  
  def index
    @org = Org.first
    @projects = Project.all(:include => [:commits, :coders])
    @projects_by_commit_size = @projects.collect { |x| [x, x.commits.size]}.sort_by {|x| x[1]}.reverse    
    @projects_by_coder_size = @projects.collect { |x| [x, x.coders.size]}.sort_by {|x| x[1]}.reverse    
    @commits = Commit.all(:include => [:coder, :project])
    @coders = Coder.all(:include => [:projects, :commits])
    @coders_by_commit_size = @coders.collect { |x| [x, x.commits.size]}.sort_by {|x| x[1]}.reverse    
  end
  
end
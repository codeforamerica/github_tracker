class DashboardController < ApplicationController
  
  def index
    @org = Org.first
    @projects = Project.all(:order => "created_at ASC", :include => [:commits, :coders])
    @projects_by_commit_size = @projects.collect { |x| [x, x.commits.size]}.sort_by {|x| x[1]}.reverse    
    @projects_by_coder_size = @projects.collect { |x| [x, x.coders.size]}.sort_by {|x| x[1]}.reverse    
    @commits = Commit.all(:include => [:coder, :project])
    @coders = Coder.all(:order => "first_commit ASC",:include => [:projects, :commits])
    @coders_by_commit_size = @coders.collect { |x| [x, x.commits.size]}.sort_by {|x| x[1]}.reverse    
    @visits = Counter.all(:order => "created_at DESC")
  end
  
end
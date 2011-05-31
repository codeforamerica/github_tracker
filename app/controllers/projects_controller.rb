class ProjectsController < ApplicationController
  layout "application"

  # returns projects in json based upon certain paramters
  #
  # @path /projects.json
  # @path /:organization/projects.json  
  # @path /:organization/:name.json    
  # @param :organization
  # @param created_at>
  # @param created_at<
  # @param watchers<      
  # @param watchers>
  # @param open_issues<      
  # @param open_issues>          
  # @param size<      
  # @param size>  
  # @param fork [true,false]    
  # @return Project or Projects
  # @example /codeforamerica/shortstack.json

  def index
    
    conditions(Project)
    
    if params[:organization]
      org = Org.where(:name => params[:organization]).first
    end
    
    if params[:project_name]
      @conditions << "projects.name = #{params[:project_name]}" unless org.nil? 
    end
    
    @conditions << "orgs.org_id = #{org.id}" unless org.nil? 

    @projects = Project.includes(:commits, :coders).where(@conditions.join(" and ")).order("created_at DESC")
    @coders = Coder.all
    @projects_by_coder_size = @projects.collect { |x| [x, x.coders.uniq.size]}.sort_by {|x| x[1]}.reverse
    @projects_by_commit_month_size = @projects.collect { |x| [x, x.commits.where("committed_date > '#{1.month.ago}'").size]}.sort_by {|x| x[1]}.reverse        
    @projects_by_commit_week_size = @projects.collect { |x| [x, x.commits.where("committed_date > '#{1.week.ago}'").size]}.sort_by {|x| x[1]}.reverse            
    
    @items = [:results => @projects.size, :page => (params[:page].nil? ? 1 : params[:page]), :total_items => @projects.size]  
    respond_to do |format|
      format.json { render :json => [@items, @projects].to_json}
      format.html
    end
  end
    

end

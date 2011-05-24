class ProjectsController < ApplicationController

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
    
    @conditions << {"org_id" => org.id} unless org.nil? 
    
    @project = Project.where(@conditions).paginate(
      :per_page => 25, :page => params[:page])
    
    @items = [:results => @project.size, :page => (params[:page].nil? ? 1 : params[:page]), :total_items => @project.total_entries]  
    respond_to do |format|
      format.json { render :json => [@items, @project].to_json}      
    end
  end
  

end

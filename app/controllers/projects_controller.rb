class ProjectsController < ApplicationController

  # returns organizations in json based upon certain paramters
  #
  # @path /organizations.json
  # @path /:org_login.json  
  # @param org_login
  # @param created_at>
  # @param created_at<
  # @param followers_count<      
  # @param followers_count>
  # @param following_count<      
  # @param following_count>          
  # @return Organization or Organizations
  # @example Organization.new.get_details("codeforamerica")

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

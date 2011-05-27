class CodersController < ApplicationController
  # returns coders in json based upon certain paramters
  #
  # @path /coders.json
  # @path /coders/:login.json  
  # @path /:org_login/coders.json  
  # @path /:org_login/:name/coders.json    
  # @param :org_login Organization name
  # @param :name Project name
  # @param :login Code Login
  # @param created_at>
  # @param created_at<
  # @param followers_count<      
  # @param followers_count>
  # @param following_count<      
  # @param following_count> 
  # @param public_repo_count<      
  # @param public_repo_count>           
  # @param public_gist_count<      
  # @param public_gist_count>  
  # @return Coders.
  # @example /coders.json /coders/sferik.json /codeforamerica/shortstack/coders.json

  def index
    
    conditions(Coder)
    
    if params[:org_login]
      org = Org.where(:name => params[:organization]).first
    end
    
    if params[:project_name]
      project = Project.where(:name => params[:project_name]).first
    end
    
    @conditions << "commits.org_id = '#{org.id}'" unless org.nil?     
    @conditions << "commits.project_id = '#{project.id}'" unless project.nil?         
    
    @coders = Coder.includes(:commits).where(@conditions.join(" and "))
      
    @items = [:results => @coders.size, :page => (params[:page].nil? ? 1 : params[:page]), :total_items => @coders.size]    
    
    respond_to do |format|
      format.json { render :json => [@items, @coders].to_json}    
      format.html  
    end
  end
  
  def projects
    @coder = Coder.where(:login => params[:login]).first
    
    respond_to do |format|
      format.json { render :json => [@coder, :projects => [@coder.projects]].to_json}      
    end  
  end
    
end

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
  # @return Coders
  # @example /coders.json /coders/sferik.json /codeforamerica/shortstack/coders.json

  def index
    
    conditions(Coder)
    
    if params[:org_login]
      org = Org.where(:name => params[:organization]).first
    end
    
    @conditions << {"org_id" => org.id} unless org.nil?     
    
    @coder = Coder.where(@conditions).paginate(
      :per_page => 25, :page => params[:page])
      
    @items = [:results => @coder.size, :page => (params[:page].nil? ? 1 : params[:page]), :total_items => @coder.total_entries]    
    
    respond_to do |format|
      format.json { render :json => [@items, @coder].to_json}      
    end
  end
    
end

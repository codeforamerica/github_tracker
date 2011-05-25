class OrganizationsController < ApplicationController

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
      conditions(Org)
    
      @org = Org.where(@conditions.join(" and ")).paginate(
        :per_page => 25, :page => params[:page])
    
      respond_to do |format|
        format.json { render :json => @org.to_json}      
      end
  end

end

class CommitsController < ApplicationController
  def index
    
    conditions(Commit)
    
    if params[:name]
      project = Project.where(:name => params[:name]).first
    end
    
    if params[:coder_login] 
      coder = Coder.where(:login => params[:coder_login]).first
    end
    
    if params[:org_login] 
      org = Org.where(:login => params[:org_login]).first
    end
    
    @conditions["coder_id"] = coder.id unless coder.nil?
    # @conditions << {:org_id => coder.id} unless org.nil?     
    # @conditions << {:project_id => project.id} unless project.nil?   
    
    puts @conditions      
    @commits = Commit.where(@conditions).paginate(
      :per_page => 25, :page => params[:page])

    respond_to do |format|
      format.json { render :json => @commits.to_json}      
    end
  end

end

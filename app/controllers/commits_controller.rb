class CommitsController < ApplicationController
  def index
    
    conditions(Commit)
    
    if params[:coder_name]
      coder = Coder.where(:name => params[:coder_name]).first
    end
    
    @conditions << {"coder_id" => coder.id} unless coder.nil? 

    
    @commits = Commit.where(@conditions).paginate(
      :per_page => 25, :page => params[:page])

    respond_to do |format|
      format.html
      format.json { render :json => @commits.to_json}      
      format.xml  { render :xml => @commits.to_xml }
    end
  end

end

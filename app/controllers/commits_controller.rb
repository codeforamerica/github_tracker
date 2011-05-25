class CommitsController < ApplicationController
  def index
    
    conditions(Commit)
    
    project = Project.where(:name => params[:name]).first unless params[:name].nil?
    coder = Coder.where(:login => params[:coder_login]).first unless params[:coder_login].nil?
    org = Org.where(:login => params[:org_login]).first  unless params[:org_login].nil?
    
    @conditions << "coder_id = '#{coder.id}'" unless coder.nil?
    @conditions << "org_id = '#{org.id}'" unless org.nil?     
    @conditions << "project_id = '#{project.id}'" unless project.nil?   

    @commits = Commit.where(@conditions.join(" and ")).paginate(
      :per_page => 25, :page => params[:page])

    @items = [:results => @commits.size, :page => (params[:page].nil? ? 1 : params[:page]), :total_items => @commits.total_entries]  

    respond_to do |format|
      format.json { render :json => [@items, @commits].to_json}      
    end
  end

end

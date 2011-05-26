class CounterController < ApplicationController
  def index
    project = Project.where(:name => params[:name]).first
    if !project.blank? 
      project.counters.create!
    end
    render :text => File.read("public/images/logo.png") ,:status => 200, :content_type => 'image/png' 
  end

end

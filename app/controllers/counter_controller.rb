class CounterController < ApplicationController
  def index
    project = Project.where(:name => params[:name]).first
    if !project.blank? 
      project.counters.create!
    end
    
    respond_to do |format|
      format.png do
        response.headers['Cache-Control'] = 'no-cache'
        response.headers["Expires"] = CGI.rfc1123_date(Time.now)
        send_file(Rails.public_path + "/images/logo.png", :type => 'image/png', :disposition => 'inline')
      end
    end
  end

end

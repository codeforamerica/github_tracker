require 'spec_helper'

describe ProjectsController do

  describe "GET 'index'" do
    
    before do
      Project.delete_all
      2.times {Factory(:project)}
    end
      
     it "should return all projects from json call" do
         get 'index', :format => :json
         response.should be_success
         assigns(:projects).size.should == 2
       end
       
       it "should return one project when passed a project name from json call" do
         project = Factory(:project)
         Project.count.should > 1
         get "index", :name => project.name, :format => :json
         response.should be_success
         assigns(:projects).size.should == 1
         ActiveSupport::JSON.decode(response.body)[1].should == [ActiveSupport::JSON.decode(project.to_json)]
       end
         
       it "should return projects with watchers > and < then 1" do
         
         project = Factory(:project, :watchers => 1)
       
         get "index", "watchers>" => 2, :format => :json
         response.should be_success
         assigns(:projects).size.should == 2
       
         get "index", "watchers<" => 2, :format => :json
         response.should be_success
         assigns(:projects).size.should == 1
         
         get "index", "watchers" => 1, :format => :json
         response.should be_success
         assigns(:projects).size.should == 1
         
       end
      
      it "should return projects with created_at dates >, <" do
        
        project = Factory(:project, :created_at => Time.now - 1.year)
              
        get "index", "created_at>" => Time.now - 1.month, :format => :json
        response.should be_success
        assigns(:projects).size.should == 2
            
        get "index", "created_at<" => Time.now - 1.month, :format => :json
        response.should be_success
        assigns(:projects).size.should == 1
        
        get "index", "created_at>" => Time.now - 1.year, "created_at<" => Time.now - 1.month, :format => :json
        response.should be_success
        assigns(:projects).size.should == 1
        
      end
      
      it "should return projects that are forks or not" do
        project = Factory(:project, :fork => true)
        
        get "index", "fork" => 't', :format => :json
        response.should be_success
        assigns(:projects).size.should == 1
        
        get "index", "fork" => 'f', :format => :json
        response.should be_success
        assigns(:projects).size.should == 2
        
      end
    
    it "should return projects > < size" do
      project = Factory(:project, :size => 1)
      get "index", "size>" => 2, :format => :json
      response.should be_success
      assigns(:projects).size.should == 2
      
      get "index", "size<" => 2, :format => :json
      response.should be_success
      assigns(:projects).size.should == 1
    end
    
    it "should return projects with > < open issues" do
      
      project = Factory(:project, :open_issues => 10)
      
      get "index", "open_issues>" => 1, :format => :json
      response.should be_success
      assigns(:projects).size.should == 1
      
      get "index", "open_issues<" => 5, :format => :json
      response.should be_success
      assigns(:projects).size.should == 2
    end
    
    after do
      Org.delete_all
      Project.delete_all
    end

  end

end

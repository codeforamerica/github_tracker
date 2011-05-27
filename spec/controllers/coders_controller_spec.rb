require 'spec_helper'

describe CodersController do
  
  describe "GET 'index'" do
    before do
      Coder.delete_all
      2.times {Factory(:coder)}
    end
    
    it "should return all coders from json call" do
      get 'index', :format => :json
      response.should be_success
      assigns(:coders).size.should == 2
    end
    
    it "should return one coder when passed login from json call" do
      coder = Factory(:coder)
      Coder.count.should > 1
      get "index", :login => coder.login, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      ActiveSupport::JSON.decode(response.body)[1].should == [ActiveSupport::JSON.decode(coder.to_json)]
    end
    
    it "should return coders with followers >, < and = then 1" do
      coder = Factory(:coder, :followers_count => 1)
    
      get "index", "followers_count>" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 2
    
      get "index", "followers_count<" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
      get "index", "followers_count" => 1, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
    end
    
    it "should return coders with following > and < then 1" do
      
      coder = Factory(:coder, :following_count => 1)
    
      get "index", "following_count>" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 2
    
      get "index", "following_count<" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
      get "index", "following_count" => 1, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
    end
    
    it "should return coders with public_repo_count > and < then 1" do
      
      coder = Factory(:coder, :public_repo_count => 1)
    
      get "index", "public_repo_count>" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 2
    
      get "index", "public_repo_count<" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
      get "index", "public_repo_count" => 1, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
    end
    
    it "should return coders with public_gist_count > and < then 1" do
      
      coder = Factory(:coder, :public_gist_count => 1)
    
      get "index", "public_gist_count>" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 2
    
      get "index", "public_gist_count<" => 2, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
      get "index", "public_gist_count" => 1, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
    end
    
    it "should return coders with created_at dates >, <" do
      
      coder = Factory(:coder, :created_at => Time.now - 1.year)
            
      get "index", "created_at>" => Time.now - 1.month, :format => :json
      response.should be_success
      assigns(:coders).size.should == 2

      get "index", "created_at<" => Time.now - 1.month, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
      get "index", "created_at>" => Time.now - 1.year, "created_at<" => Time.now - 1.month, :format => :json
      response.should be_success
      assigns(:coders).size.should == 1
      
    end
        
    after do
      Commit.delete_all
      Project.delete_all
      Coder.delete_all
      Org.delete_all
    end
    
  end
  
  describe "GET 'index'" do
    before do
      Coder.delete_all
      2.times {Factory(:coder)}
    end
    
    it "should return a coder's projects" do
      commit = Factory(:commit)      
      get "projects", :login => commit.coder.login, :format => :json
      response.should be_success
      ActiveSupport::JSON.decode(response.body).should == ActiveSupport::JSON.decode([commit.coder, :projects => [commit.coder.projects]].to_json)
    end

    after do
      Commit.delete_all
      Project.delete_all
      Coder.delete_all
      Org.delete_all
    end
  end
  
end

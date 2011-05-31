require 'spec_helper'

describe OrganizationsController do
  
  describe "GET 'index'" do
    before do
      Org.delete_all
      2.times {Factory(:org)}
    end
    
    it "should return all organizations from json call" do
      get 'index', :format => :json
      response.should be_success
      response.body.should == Org.all.to_json
      assigns(:org).size.should == 2
    end
    
    it "should return one organization when passed login from json call" do
      org = Factory(:org)
      Org.count.should > 1
      get "index", :login => org.login, :format => :json
      response.should be_success
      assigns(:org).size.should == 1
      ActiveSupport::JSON.decode(response.body).should == [ActiveSupport::JSON.decode(org.to_json)]
    end
    
    it "should return organizations with followers >, < and = then 1" do
      org = Factory(:org, :followers_count => 1)
    
      get "index", "followers_count>" => 2, :format => :json
      response.should be_success
      assigns(:org).size.should == 2
    
      get "index", "followers_count<" => 2, :format => :json
      response.should be_success
      assigns(:org).size.should == 1
      
      get "index", "followers_count" => 1, :format => :json
      response.should be_success
      assigns(:org).size.should == 1
      
    end
    
    it "should return organizations with following > and < then 1" do
      
      org = Factory(:org, :following_count => 1)
    
      get "index", "following_count>" => 2, :format => :json
      response.should be_success
      assigns(:org).size.should == 2
    
      get "index", "following_count<" => 2, :format => :json
      response.should be_success
      assigns(:org).size.should == 1
      
      get "index", "following_count" => 1, :format => :json
      response.should be_success
      assigns(:org).size.should == 1
      
    end
    
    it "should return organizations with created_at dates >, <" do
      
      org = Factory(:org, :created_at => Time.now - 1.year)
            
      get "index", "created_at>" => Time.now - 1.month, :format => :json
      response.should be_success
      assigns(:org).size.should == 2

      get "index", "created_at<" => Time.now - 1.month, :format => :json
      response.should be_success
      assigns(:org).size.should == 1
      
      get "index", "created_at>" => Time.now - 1.year, "created_at<" => Time.now - 1.month, :format => :json
      response.should be_success
      assigns(:org).size.should == 1
      
    end
        
    after do
      Org.delete_all
    end
    
  end

end

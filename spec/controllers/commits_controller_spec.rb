require 'spec_helper'

describe CommitsController do

  describe "GET 'index'" do
    before do
      2.times {Factory(:commit)}
    end
    
    it "should return all commits for a project from json call" do
        commit = Commit.last
        get 'index', :org_id => commit.org.id,  :format => :json
        response.should be_success
        Commit.count.should == 2
        assigns(:commits).size.should == 1
        ActiveSupport::JSON.decode(response.body)[1].should == [ActiveSupport::JSON.decode(commit.to_json)]        
      end
   
   it "should return all commits for a org from json call" do
       commit = Commit.last
       get 'index', :org_id => commit.org.id,  :format => :json
       response.should be_success
        Commit.count.should == 2       
       assigns(:commits).size.should == 1
       ActiveSupport::JSON.decode(response.body)[1].should == [ActiveSupport::JSON.decode(commit.to_json)]               
     end
   
   it "should return all commits for a coder from json call" do
       commit = Commit.last
       get 'index', :coder_id => commit.coder.id,  :format => :json
       response.should be_success
        Commit.count.should == 2       
       assigns(:commits).size.should == 1
       ActiveSupport::JSON.decode(response.body)[1].should == [ActiveSupport::JSON.decode(commit.to_json)]               
     end
   
   it "should return commits with committed_date dates >, <" do
     
     commit = Factory(:commit, :committed_date => Time.now - 1.year)
           
     get "index", "committed_date>" => Time.now - 1.month, :format => :json
     response.should be_success
     assigns(:commits).size.should == 2
         
     get "index", "committed_date<" => Time.now - 1.month, :format => :json
     response.should be_success
     assigns(:commits).size.should == 1
     
     get "index", "committed_date>" => Time.now - 1.year, "committed_date<" => Time.now - 1.month, :format => :json
     response.should be_success
     assigns(:commits).size.should == 1
     
   end
   
   after do
     Org.delete_all
     Project.delete_all
     Commit.delete_all
     Coder.delete_all
   end
     
  end

end

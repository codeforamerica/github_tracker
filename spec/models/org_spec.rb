require 'spec_helper'

describe Org do
  
  before do
    Org.delete_all
    Project.delete_all
    stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("organization.json"), :headers => {})
   stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica1").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 404, :body => fixture("organization_not_found.json"), :headers => {})             
    stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica/public_repositories").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("organization_repos.json"), :headers => {})          
     stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica2/public_repositories").
              with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
              to_return(:status => 200, :body => fixture("organization_update_repos.json"), :headers => {})
    end

  it "should save an organization" do
    org = Org.new.get_details("codeforamerica")
    org.name = "Code for America"
    Org.count.should == 1
  end
    
  it "should return error when organization not found" do
    org = Org.new.get_details("codeforamerica1")
    org.should == [false, "We had a problem finding that organization"]
  end
  
  it "should grab a list of projects and add them" do
    org = Org.new.get_details("codeforamerica")
    org.get_projects
    org.projects.size.should == 1
    org.projects.first.name.should == "shortstack"
  end
  
  it "should grab a list of projects, add new ones and not duplicate" do
    project = Factory(:project, {:name => "shorstack3", :org => Factory(:org, :login => "codeforamerica2")})
    org = project.org
    org.projects.size.should == 1
    org.get_new_projects
    org.projects.last.name.should == "shortstack1"
    org.projects.size.should == 2
    org.get_new_projects
    org.reload.projects.size.should == 2    
  end

  after do
    Org.delete_all
    Project.delete_all
  end
  
end
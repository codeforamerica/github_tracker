require 'spec_helper'

describe Org do
  
  before do
    stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("organization.json"), :headers => {})
   stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica1").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 404, :body => fixture("organization_not_found.json"), :headers => {})             
    stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica/public_repositories").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("organization_repos.json"), :headers => {})          

    end

  it "should save an organization" do
    Org.delete_all
    org = Org.new.get_details("codeforamerica")
    org.name = "Code for America"
    Org.count.should == 1
  end
    
  it "should return error when organization not found" do
    Org.delete_all    
    org = Org.new.get_details("codeforamerica1")
    org.should == [false, "We had a problem finding that organization"]
  end
  
  it "should grab a list of projects and add them" do
    Org.delete_all
    org = Org.new.get_details("codeforamerica")
    org.get_projects
    org.projects.size.should == 66
    org.projects.first.name.should == "cfahelloworld"
  end

  
end
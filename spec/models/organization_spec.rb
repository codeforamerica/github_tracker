require 'spec_helper'

describe Organization do
  
  before do
    stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("organization.json"), :headers => {})
   stub_request(:get, "https://github.com/api/v2/json/organizations/codeforamerica1").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 404, :body => fixture("organization_not_found.json"), :headers => {})             
    end

  it "should save an organization" do
    org = Organization.new.get_details("codeforamerica")
    org.name = "Code for America"
    Organization.count.should == 1
  end
  
  it "should not save an organization if it already exists" do
    2.times { org = Organization.new.get_details("codeforamerica")}
    Organization.count.should == 1
  end
  
  it "should return error when organization not found" do
    org = Organization.new.get_details("codeforamerica1")
    org.should == [false, "We had a problem finding that organization"]
  end
  
end
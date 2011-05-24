require 'spec_helper'

describe Coder do
  
  before do
    stub_request(:get, "https://github.com/api/v2/json/user/show/sferik").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("coder.json"), :headers => {})
    stub_request(:get, "https://github.com/api/v2/json/user/show/sferik1").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 404, :body => fixture("user_not_found.json"), :headers => {})             
    end

  it "should save an organization" do
    Coder.delete_all
    coder = Coder.new.get_details("sferik")
    coder.login = "sferik"
    Coder.count.should == 1
  end
  
  it "should return error when user not found" do
    Coder.delete_all    
    coder = Coder.new.get_details("sferik1")
    coder.should == [false, "We had a problem finding that user"]
  end
  
end
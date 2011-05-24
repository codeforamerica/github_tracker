require 'spec_helper'

describe Coder do
  
  before do
    Coder.delete_all
    stub_request(:get, "https://github.com/api/v2/json/user/show/sferik").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("coder.json"), :headers => {})
    stub_request(:get, "https://github.com/api/v2/json/user/show/sferik1").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 404, :body => fixture("user_not_found.json"), :headers => {})             
    end

  it "should save a coder" do
    coder = Coder.new.get_details("sferik")
    coder.login.should == "sferik"
    Coder.count.should == 1
  end
  
  it "should return error when user not found" do   
    coder = Coder.new.get_details("sferik1")
    coder.should == [false, "We had a problem finding that user"]
  end
  
  it "should find a coder" do
    coder = Coder.new.find_or_create("sferik")
    coder.login == "sferik"
    Coder.count.should == 1
    Coder.new.find_or_create("sferik").login.should == "sferik"
  end
  
  after do 
    Coder.delete_all
  end
  
end
require 'spec_helper'

describe CounterController do

  describe "GET 'index'" do
    it "should be successful" do
      project = Factory(:project)
      get 'index', :name => project.name
      project.reload.counters.size.should == 1
      response.should be_success
    end
  end

end

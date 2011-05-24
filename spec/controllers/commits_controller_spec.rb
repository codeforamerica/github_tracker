require 'spec_helper'

describe CommitsController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    
   pending "should grab commits for a project"
   
   pending "should grab commits for an organization"
   
   pending "should grab commits for a coder"
   
   pending "should grab commits based upon dates"
   
   pending "should grab commits based upon a sha"
     
  end

end

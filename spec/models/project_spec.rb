require 'spec_helper'

describe Project do
  
  before do
    stub_request(:get, "https://github.com/api/v2/json/repos/show/codeforamerica/shortstack").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture('repo.json'))
   stub_request(:get, "https://github.com/api/v2/json/repos/show/codeforamerica/shortstack1").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 404, :body => fixture('repo_not_found.json'))
    stub_request(:get, "https://github.com/api/v2/json/user/show/sferik").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("coder.json"), :headers => {})
    stub_request(:get, "https://github.com/api/v2/json/commits/list/codeforamerica/shortstack/master?page=1").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("project_commits.json"), :headers => {})
                         
    end

  it "should parse a correct repo url" do
    repo_name = Project.new.parse_repo("https://github.com/codeforamerica/fcc_reboot")
    repo_name.should == "codeforamerica/fcc_reboot"
  end

  it "should return an error on an incorrect repo url" do
    repo_name = Project.new.parse_repo("https://githubcom/codeforamerica/fcc_reboot")
    repo_name[0].should be false
    repo_name[1].should == "We had trouble parsing that url"
  end

  it "should save a repo" do
    repo_name = Project.new.get_details("https://github.com/codeforamerica/shortstack")
    repo_name.name.should == "shortstack"
    Project.count.should == 1
  end
  
  it "should return error when repo not found" do
    repo = Project.new.get_details("https://github.com/codeforamerica/shortstack1")
    repo.should == [false, "We had a problem finding that repository"]
  end
  
  it "should get commits" do  
    repo = Project.new.get_details("https://github.com/codeforamerica/shortstack")
    repo.get_commits(1)
    repo.commits.size.should == 2
    repo.commits.first.coder.login.should == "sferik"
  end
  
  it "should not add to commits already in the db" do
    Project.new.get_details("https://github.com/codeforamerica/shortstack")
    repo = Project.last
    2.times {repo.get_commit_history(1)}
    repo.commits.size.should == 2
  end
  
  after do
    Project.delete_all
    Commit.delete_all
  end
  
end
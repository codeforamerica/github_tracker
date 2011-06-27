class Project < ActiveRecord::Base
  
  validates_uniqueness_of :name
  has_many :commits 
  has_many :coders, :through => :commits
  has_many :counters
  belongs_to :org    

  
  # given a github url, goto github and grab the project data
  #
  # @param repo_url The url of the repo, i.e. "https://githubcom/codeforamerica/fcc_reboot"
  # @return Project or Error
  # @example Project.new.get_details("https://github.com/codeforamerica/shortstack")
  
  def get_details(repo_url)  
    repo_name = parse_repo(repo_url)
    if repo_name[0] 
      begin
        repo = Octokit.repo(repo_name.join)
      rescue
        return false, "We had a problem finding that repository"
      else
        org =  Org.new.find_or_create(repo.organization)
        repo["org_id"] = org.id
        col = Project.columns.map(&:name)
        repo.delete_if { |key| !col.include?(key)}        
        return Project.create!(repo)
      end
    else
      return false, repo_name
    end
  end
  
  # given a github url, goto github and update the project data
  #
  # @param repo_url The url of the repo, i.e. "https://githubcom/codeforamerica/fcc_reboot"
  # @return Project or Error
  # @example Project.new.get_details("https://github.com/codeforamerica/shortstack")
  
  def update_details  
        repo = Octokit.repo(self.org.login + "/" + self.name)
      begin

        self.update_attributes(repo)
      rescue
        return false, "We had a problem finding that repository"
      end
  end  

  # given a github url, parse the url and return a string
  #
  # @param repo_url The url of the repo, i.e. "https://githubcom/codeforamerica/fcc_reboot"
  # @return String or Error
  # @example Project.new.parse_repo("https://github.com/codeforamerica/shortstack")
  
  def parse_repo(url)
    begin
      domain = Domainatrix.parse(url)
    rescue 
      return false, "We had trouble parsing that url"
    else
      repo_name = [domain.path.split("/")[1], "/", domain.path.split("/")[2]]
    end
  end

  # grab the commits for a repository
  #
  # @param page and the branch
  # @return last commit or Error
  # @example Project.first.get_commits(1)
  def get_commits(page, branch = "master")
    repo_name = parse_repo(self.url)
    begin
      c = Octokit.commits(repo_name.join, "master", {:page => page})
      c.each do |commit|
        coder = Coder.new.find_or_create(commit.author.login)
        coder_exists = coder.is_a? Coder #if we've been given back something other than a coder because we couldn't find a user, this will be false
        options = {:sha => commit.id, :project_id => self.id, :org_id => self.org.id, :branch => branch, :message => commit.message, :coder_id => coder_exists ? coder.id : nil, :committed_date => commit.committed_date}
        Commit.new.find_or_create(options)    
        if coder_exists && coder.reload.first_commit.nil?
          coder.update_attributes(:first_commit => coder.commits.last.committed_date)
        end
      end      
    rescue 
      return false, "No commits here!"
    end
  end
  
  # uses Delayed Job to scan through pages looking for commits
  #
  # @param page and the branch
  # @return last commit or Error
  # @example Project.first.get_commits(1)
  def get_commit_history(page=1)
    current_commits_size = self.commits.size
    c = self.get_commits(page)
    if c[0] == false 
    else
      self.delay.get_commit_history(page+1)
    end
    
  end
  
end

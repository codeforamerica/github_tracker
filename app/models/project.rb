class Project 
  include Mongoid::Document
  field :homepage 
  field :has_downloads
  field :forks, type: Integer
  field :url 
  field :watchers, type: Integer
  field :has_wiki
  field :fork, type: Boolean
  field :open_issues, type: Integer
  field :created_at, type: DateTime
  field :organization
  field :description
  field :size, type: Integer
  field :private
  field :has_issues
  field :name
  field :owner
  field :org_id

  index :name, :uniq => true  
  index :org_id
  index :organization
  index :fork
  index :forks  
  index :open_issues
  index :created_at
  index :size
  index :watchers
  
  validates_uniqueness_of :name
  has_many :commits 
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
        return Project.create!(repo)
      end
    else
      return false, repo_name
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
        options = {:sha => commit.id, :project_id => self.id, :org_id => self.org.id, :branch => branch, :message => commit.message, :coder_id => coder.id, :committed_date => commit.committed_date}
        Commit.new.find_or_create(options)    
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
  
  # mongo's not so great about has many through, so we'll have to pull them manually
  def coders
    coders = []
    self.commits.distinct(:coder_id).each {|x| coders << Coder.where(:_id => x).first }
    coders
  end

  
end
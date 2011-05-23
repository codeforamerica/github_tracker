class Project 
  include Mongoid::Document
  validates_uniqueness_of :name
  
  # given a github url, goto github and grab the project data
  #
  # @param repo_url The url of the repo, i.e. "https://githubcom/codeforamerica/fcc_reboot"
  # @return Project or Error
  # @example Project.new.get_project("https://github.com/codeforamerica/shortstack")
  
  def get_details(repo_url)  
    repo_name = parse_repo(repo_url)
    if repo_name[0] 
      begin
        repo = Octokit.repo(repo_name)
      rescue
        return false, "We had a problem finding that repository"
      else
        Project.create(repo)
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
      repo_name = domain.path.split("/")[1] + "/" + domain.path.split("/")[2]
    end
  end
  
end
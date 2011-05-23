class Organization 
  include Mongoid::Document
  validates_uniqueness_of :login

  # given an organization name, goto github and grab the organization details and create a new org
  #
  # @param repo_url The url of the repo, i.e. "https://githubcom/codeforamerica/fcc_reboot"
  # @return Project or Error
  # @example Project.new.get_project("https://github.com/codeforamerica/shortstack")
  
  def get_details(name)
    begin
      org = Octokit.organization(name) 
    rescue
      return false, "We had a problem finding that organization"
    else
      Organization.create(org)
    end
  end

end

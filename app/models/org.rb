class Org
  include Mongoid::Document
  references_many :projects
  references_many :coders    
  validates_uniqueness_of :login

  # given an organization name, goto github and grab the organization details and create a new org
  #
  # @param name The url of the repo, i.e. "codeforamerica"
  # @return Organization or Error
  # @example Organization.new.get_details("codeforamerica")
  
  def get_details(name)
    begin
      org = Octokit.organization(name) 
    rescue
      return false, "We had a problem finding that organization"
    else
      Org.create!(org)
    end
  end

  # goto github and grab the organization projects
  #
  # @return projects or Error
  # @example Organization.new.get_details("codeforamerica")
  
  def get_projects
    begin
      repos = Octokit.organization_repositories(self.login)
    rescue
      self.update_attributes(:flag => true, :error_message => "We had a problem finding that organization")
      return false, "We had a problem finding that organization"
    else
      repos.each do |repo|
        self.projects.create(repo)        
      end
      self.projects
    end
  end

end
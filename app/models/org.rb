class Org
  include Mongoid::Document
  has_many :projects   
  has_many :commits      

  field :id
  field :gravatar_id
  field :company
  field :name
  field :created_at, type: DateTime
  field :location
  field :public_repo_count, type: Integer
  field :public_gist_count, type: Integer
  field :blog
  field :following_count, type: Integer
  field :type
  field :followers_count, type: Integer
  field :login 
  field :email
  
  index :id, :uniq => true
  index :login, :uniq => true
  index :email
  index :followers_count
  index :following_count
  index :created_at    
  
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
  
  # given a org name, find and return it or goto github and grab the org details and return a new coder
  #
  # @param name The username of the coder i.e. sferik
  # @return Github user object or error
  # @example Org.new.find_or_create("codeforamerica")
  
  def find_or_create(name)
    org = Org.where(:login => name).first
    !org.blank? ? org : self.get_details(name)
  end

  # mongo's not so great about has many through, so we'll have to pull them manually  
  def coders
    coders = []
    self.commits.distinct(:coder_id).each {|x| coders << Coder.where(:_id => x).first }
    coders
  end


end

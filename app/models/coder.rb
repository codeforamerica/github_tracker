class Coder 
  include Mongoid::Document
  has_many :commits

  field :org_id 
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
  
  index :org_id
  index :login
  index :following_count
  index :followers_count
  index :public_repo_count  
  index :public_gist_count    
  index :created_at
    
  validates_uniqueness_of :login
  
  # given a coder name, goto github and grab the user details and create a new coder
  #
  # @param name The username of the coder i.e. sferik
  # @return Github user object or error
  # @example Coder.new.get_details("sferik")
  
  def get_details(name)
    begin
      coder = Octokit.user(name) 
    rescue
      return false, "We had a problem finding that user"
    else
      return Coder.create!(coder)
    end
  end

  # given a coder name, find and return it or goto github and grab the user details and return a new coder
  #
  # @param name The username of the coder i.e. sferik
  # @return Github user object or error
  # @example Coder.new.get_details("sferik")
  
  def find_or_create(name)
    coder = Coder.where(:login => name).first
    !coder.blank? ? coder : self.get_details(name)
  end
  
  # mongo's not so great about has many through, so we'll have to pull them manually
  def projects
    projects = []
    self.commits.distinct(:project_id).each {|x| projects << Project.where(:_id => x).first }
    projects
  end
  


end

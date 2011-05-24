class Coder 
  include Mongoid::Document
  references_many :projects 
  referenced_in :organization 
    
  field :id 
  field :organization_id 
  field :gravatar_id 
  field :company
  field :name
  field :created_at
  field :location
  field :public_repo_count
  field :public_gist_count
  field :blog
  field :following_count
  field :type
  field :followers_count
  field :login
  field :email
  
  index :id
  index :organizaation_id
  index :login
  index :following_count
  index :followers_count
  index :public_repo_count  

  
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

end

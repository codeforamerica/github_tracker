class Coder 
  include Mongoid::Document
  validates_uniqueness_of :login

  # given a coder name, goto github and grab the user details and create a new coder
  #
  # @param name The username of the coder i.e. sferik
  # @return Coder
  # @example Coder.new.get_details("sferik")
  
  def get_details(name)
    begin
      coder = Octokit.user(name) 
    rescue
      return false, "We had a problem finding that user"
    else
      Coder.create(coder)
    end
  end

end

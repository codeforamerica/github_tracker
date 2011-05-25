class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def conditions(model)
    @conditions = []
     operators = [">", "<", "!"]

     params.each do |key,value|
       operator = nil
       if key =~ /^(.*?)(#{operators.join "|"})$/
         key = $1
         operator = $2
       end

       next if not model.columns.map(&:name).include? key # allow filtering only on indexed fields

       if operator
         @conditions << key.to_s + " " + operator + "='" + value.to_s + "'" 
       else
         @conditions << key.to_s + " " + "='" + value.to_s + "'" 
       end
       
     end
  end
end

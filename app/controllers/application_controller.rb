class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def conditions(model)
    @conditions = {}

     operators = {
       ">" => :gte, 
       "<" => :lte, 
       "!" => :ne,
       "__in" => :in,
       "__nin" => :nin,
       "__all" => :all
     }

     params.each do |key,value|
       operator = nil

       if key =~ /^(.*?)(#{operators.keys.join "|"})$/
         key = $1
         operator = operators[$2]
       end
       
       next if not model.index_options.include? key.to_sym # allow filtering only on indexed fields

       if [:nin, :in, :all].include? operator
         value = value.split(",")
       end

       if operator
         if @conditions[key].nil? or @conditions[key].is_a?(Hash)
           @conditions[key] ||= {}
           @conditions[key]["$#{operator}"] = value 
         else
           # this key is already assigned, ignore it
         end
       else
         @conditions[key] = value
       end
     end
  end
end

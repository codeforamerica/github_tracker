GithubTracker::Application.routes.draw do
  get "counter/index"

  match ':organization/:name.png' => 'counter#index'
  match ':organization/projects' => 'projects#index'    
  
  match 'dashboard' => 'dashboard#index'
  match 'organizations' => 'organizations#index'
  match 'projects' => 'projects#index'
  match 'coders' => 'coders#index'
  match 'commits' => 'commits#index'        
      
  match 'organizations/:login'=> 'organizations#index', :format => :get
  match 'organizations/:login/projects'=> 'projects#index', :format => :get
  match 'organizations/:org_login/commits' => 'commits#index', :format => :get
  match 'organizations/:login/:name'=> 'projects#index', :format => :get
  match 'organizations/:login/coders' => 'coders#index', :format => :get   
  match 'projects/:project_name/coders' => 'coders#index', :format => :get     
  match 'projects/:name' => 'projects#index', :format => :get       
  match 'coders/:coder_login/commits' => 'commits#index', :format => :get
  match 'coders/:login' => 'coders#index', :format => :get  
  match 'coders/:login/projects' => 'coders#projects', :format => :get  
  match 'projects/:name/commits' => 'commits#index', :format => :get    

  root :to => 'dashboard#index'

end

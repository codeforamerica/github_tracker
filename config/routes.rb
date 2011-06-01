GithubTracker::Application.routes.draw do
  get "counter/index"

  match ':organization/:name.png' => 'counter#index'
  match ':organization/:name' => 'dashboard#index'  
  
  match 'dashboard' => 'dashboard#index'
  match 'organizations' => 'organizations#index'
  match 'projects' => 'projects#index'
  match 'coders' => 'coders#index'
  match 'commits' => 'commits#index'        
      
  match 'organizations/:login'=> 'organizations#index', :format => :json
  match 'organizations/:login/projects'=> 'projects#index', :format => :json
  match 'organizations/:org_login/commits' => 'commits#index', :format => :json
  match 'organizations/:login/:name'=> 'projects#index', :format => :json
  match 'organizations/:login/coders' => 'coders#index', :format => :json   
  match 'projects/:project_name/coders' => 'coders#index', :format => :json     
  match 'projects/:name' => 'projects#index', :format => :json       
  match 'coders/:coder_login/commits' => 'commits#index', :format => :json
  match 'coders/:login' => 'coders#index', :format => :json  
  match 'coders/:login/projects' => 'coders#projects', :format => :json  
  match 'projects/:name/commits' => 'commits#index', :format => :json    

  match ':organization/:project_name' => 'projects#show' 
  root :to => 'dashboard#index'

end

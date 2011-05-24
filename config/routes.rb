GithubTracker::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'organizations' => 'organizations#index'
  match 'projects' => 'projects#index'  
  match 'coders' => 'coders#index'    
  match 'commits' => 'commits#index'  
  match ':login' => 'organizations#index', :format => :get
  match ':organization/projects' => 'projects#index', :format => :get    
  match ':organization/:name' => 'projects#index', :format => :get  
  match ':login/commits' => 'commits#index', :format => :get
  match ':login/:name/commits' => 'commits#index', :format => :get 
  root :to => 'organizations#index'

end

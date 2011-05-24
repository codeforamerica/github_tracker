Factory.sequence(:login) { |n| "something#{n}" }


Factory.define :org do |f|
  f.name "Code for America"
  f.created_at Time.now
  f.location "San Francisco"
  f.public_repo_count 19
  f.public_gist_count 0
  f.following_count 25
  f.followers_count 35
  f.login { Factory.next(:login) }
  f.sequence(:email) { |n| "test#{n}@example.com" }
end

Factory.define :coder do |f|
  f.name "Code for America"
  f.created_at Time.now
  f.location "San Francisco"
  f.public_repo_count 19
  f.public_gist_count 0
  f.following_count 25
  f.followers_count 35
  f.sequence(:login) { |n| "something#{n}" }
  f.sequence(:email) { |n| "test#{n}@example.com" }

end

Factory.define :coder_in_org, :parent => :org do |f|
  f.org {Factory(:org)}
end

Factory.sequence :name do |n|
  "some_project_name#{n}" 
end

Factory.define :project do |f|
  f.forks "1"
  f.watchers 5
  f.fork false
  f.open_issues 0
  f.created_at Time.now
  f.size 7000
  f.name {Factory.next(:name)}
  f.organization {Factory.next(:login)}
  f.org {Factory(:org)}
end
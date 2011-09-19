# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

GithubTracker::Application.load_tasks

namespace :orgs do
  desc "Update org projects"
  task :new_projects => :environment do
    begin
      Org.all.each { |x| x.delay.get_new_projects}
    end
  end
end

namespace :projects do
  desc "Update project details"
  task :update => :environment do
    begin
      Project.all.each { |x| x.delay.update_details}
    end
  end
end

namespace :commits do
  desc "Grab new commits for projects"
  task :get => :environment do
    begin
      Project.all.each { |x| x.delay.get_commit_history(1)}
    end
  end
  
  desc "Cleanup coder straggler"
  task :clean => :environment do
    begin
      CronProcess.new.delay(:run_at => Time.now + 1.minute).clean_coders
      CronProcess.new.delay(:run_at => Time.now + 1.minute).clean_projects      
    end
  end
end
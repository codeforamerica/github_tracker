# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

GithubTracker::Application.load_tasks

namespace :heroku do
  desc "PostgreSQL database backups from Heroku to Amazon S3"
  task :backup => :environment do
    begin
      require 'right_aws'
      puts "[#{Time.now}] heroku:backup started"
      name = "#{ENV['APP_NAME']}-#{Time.now.strftime('%Y-%m-%d-%H%M%S')}.dump"
      db = ENV['DATABASE_URL'].match(/postgres:\/\/([^:]+):([^@]+)@([^\/]+)\/(.+)/)
      system "PGPASSWORD=#{db[2]} pg_dump -Fc --username=#{db[1]} --host=#{db[3]} #{db[4]} > tmp/#{name}"
      s3 = RightAws::S3.new(ENV['s3_access_key_id'], ENV['s3_secret_access_key'])
      bucket = s3.bucket("#{ENV['APP_NAME']}-heroku-backups", true, 'private')
      bucket.put(name, open("tmp/#{name}"))
      system "rm tmp/#{name}"
      puts "[#{Time.now}] heroku:backup complete"
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
      CronProcess.new.delay.clean_coders
      CronProcess.new.delay.clean_projects      
    end
  end
end



task :cron => :environment do
  Rake::Task['heroku:backup'].invoke
  Rake::Task['commits:get'].invoke  
  Rake::Task['commits:clean'].invoke    
end
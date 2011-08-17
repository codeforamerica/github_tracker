task :cron => :environment do
  Rake::Task['orgs:new_projects'].invoke
  Rake::Task['projects:update'].invoke
  Rake::Task['commits:get'].invoke  
  Rake::Task['commits:clean'].invoke    
end
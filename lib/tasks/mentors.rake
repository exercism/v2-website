namespace :mentors do
  task :remind_overdue => :environment do
    loop do
      RemindOverdueSolutionMentorships.()
      sleep(10*60) # Sleep for 10mins
    end
  end

  task :abandon_overdue => :environment do
    loop do
      AbandonOverdueSolutionMentorships.()
      sleep(10*60) # Sleep for 10mins
    end
  end
end

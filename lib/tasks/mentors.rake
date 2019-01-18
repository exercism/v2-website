namespace :mentors do
  task :remind_overdue => :environment do
    RemindOverdueSolutionMentorships.()
  end

  task :abandon_overdue => :environment do
    AbandonOverdueSolutionMentorships.()
  end
end

namespace :mentors do
  task :remind_overdue => :environment do
    loop do
      begin
        RemindOverdueSolutionMentorships.()
      rescue => e
        Bugsnag.notify(e)
      end

      sleep(10*60) # Sleep for 10mins
    end
  end

  task :abandon_overdue => :environment do
    loop do
      begin
        AbandonOverdueSolutionMentorships.()
      rescue => e
        Bugsnag.notify(e)
      end

      sleep(10*60) # Sleep for 10mins
    end
  end

  task :send_mentors_weekly_update => :environment do
    begin
      GenerateMentorHeartbeats.()
    rescue => e
      Bugsnag.notify(e)
      raise
    end
  end
end

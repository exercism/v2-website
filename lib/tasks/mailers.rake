namespace :mailers do
  task :deliver_side_exercise_changes => :environment do
    users = User.distinct.where(id:
      Iteration.where("iterations.created_at > ?", Exercism::V2_MIGRATED_AT).
      joins("INNER JOIN solutions on solutions.id = iterations.solution_id").
      distinct.
      select(:user_id)
    ).
    joins(:communication_preferences).
    where('communication_preferences.receive_product_updates': true).
    order('id asc')

    users.each do |user|
      begin
        NewsletterMailer.with(user: user).side_exercise_changes.deliver
        p "+ #{user.id}"
      rescue
        p "- #{user.id}"
      end
    end
  end

  task :deliver_mentor_changes_1  => :environment do
    users = User.
      where(id: TrackMentorship.select(:user_id)).
      order('users.id asc')

    users.each do |user|
      begin
        NewsletterMailer.with(user: user).mentor_changes_1.deliver
        p "+ #{user.id}"
      rescue
        p "- #{user.id}"
      end
    end
  end

  task :deliver_mentor_jan_2019  => :environment do
    users = User.
      where(id: TrackMentorship.select(:user_id)).
      order('users.id asc')

    users.each do |user|
      begin
        NewsletterMailer.with(user: user).mentor_jan_2019.deliver
        p "+ #{user.id}"
      rescue
        p "- #{user.id}"
      end
    end
  end

end

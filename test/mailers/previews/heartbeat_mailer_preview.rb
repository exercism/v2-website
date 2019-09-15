# Preview all emails at http://localhost:3000/rails/mailers/newsletter_mailer
class HeartbeatMailerPreview < ActionMailer::Preview
  def mentoring_heartbeat
    data = {
      site: {
        num_solutions: 5000,
        num_solutions_for_mentoring: 3000,
        num_solution_mentorships: 2000,
        num_learners: 400,
        num_mentors: 100
      },
      tracks: {
        ruby: {
          title: "Ruby",
          stats: {
             new_solutions_submitted: 5,
             solutions_submitted_for_mentoring: 3,
             total_solutions_mentored: 2,
             solutions_mentored_by_you: 1,
             current_queue_length: 18,
          }
        }
      },
      num_solutions_mentored_by_user: 10
    }
    introduction = %Q{There's nothing new to report this week but we're now close to launching the Ruby automated mentoring solution for two-fer. We'll follow up with more information on that next week. Here are this weeks stats.}
    HeartbeatMailer.mentor_heartbeat(User.first, data, introduction)
  end
end

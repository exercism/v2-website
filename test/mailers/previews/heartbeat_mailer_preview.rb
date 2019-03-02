# Preview all emails at http://localhost:3000/rails/mailers/newsletter_mailer
class HeartbeatMailerPreview < ActionMailer::Preview
  def mentoring_heartbeat
    data = {
      site: {
        num_solutions: 5,
        num_solutions_for_mentoring: 3,
        num_solution_mentorships: 2,
        num_learners: 4,
        num_mentors: 1
      },
      tracks: {
        ruby: {
          title: "Ruby",
          stats: {
             new_solutions_submitted: 5,
             solutions_submitted_for_mentoring: 3,
             current_queue_length: 18,
             total_solutions_mentored: 2,
             solutions_mentored_by_you: 1,
          }
        }
      }
    }
    introduction = %Q{Welcome to your first Mentor Heartbeat!\n\nEach week, we'll be sending you an email that summarises the activity on each track you're mentoring. We'll also include information on any changes or updates to the mentoring side of Exercism. If you have any ideas on what you'd like to see here, please open an issue at on GitHub and let us know your thoughts. If you want to opt out, there's a link at the bottom of the email. Finally I just want to say a huge thank you for your hard work and for the thousands of people you're all helping on Exercism!}
    HeartbeatMailer.mentor_heartbeat(User.first, data, introduction)
  end
end

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
      tracks: [
        {
          title: "Ruby",
          stats: {
             new_solutions_submitted: 5,
             solutions_submitted_for_mentoring: 3,
             current_queue_length: 18,
             total_solutions_mentored: 2,
             solutions_mentored_by_you: 1,
          }
        }
      ]
    }
    introduction = %q{Starting from today, we'll be sending you a brief weekly summary on the state of each track you're mentoring, along with some information on any changes or updates to the mentoring side of Exercism that have occurred during the week. If you have any thoughts or ideas on what you'd like to see here, please open an issue at on GitHub. If you want to opt out, there's a link at the bottom of the email. Which leaves me just to say a huge thank you for your hard work!} 
    HeartbeatMailer.mentor_heartbeat(User.first, data, introduction)
  end
end

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
    introduction = %Q{We get a lot of questions in Slack and on GitHub about what Exercism's current priorities are and why we've made those decisions. To try and help be more clear and transparent about this we've added a strategy document to the website, which lays out what we're trying to achieve in 2019 and how we're progressing. You might like to have a read: https://exercism.io/strategy}
    HeartbeatMailer.mentor_heartbeat(User.first, data, introduction)
  end
end

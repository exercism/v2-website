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
    introduction = %Q{This week I want to draw attention to the Track Anatomy Project - the work Maud and our maintainers are doing in restructuring tracks to make them more enjoyable to work through and easier to mentor. Our initial testbed has been Ruby, where we've seen a reduction in the average time-to-mentor from days to only a couple of hours. The maintainers of C#, JavaScript, Rust, Python, Haskell, Elixir and Prolog are all working on implementing Maud's work on their tracks too, so if you mentor those tracks, you should start to notice an improvement in your mentoring experience over the coming weeks. Thank you to everyone involved!\n\nHere are this weeks mentoring stats:}
    HeartbeatMailer.mentor_heartbeat(User.first, data, introduction)
  end
end

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
    introduction = %Q{This week our core team has started working on the Automated Mentoring Support Project. Our canonical prototype is the implementation of automatic approval for the two-fer exercise in Ruby, but analyzers are also being created by the community for Go, C#, Python, Java, JavaScript and Typescript. The project involves not only the development of static analysis software, but also various changes within the website, and the development of infrastructure and orchestration that can handle analysers for multiple languages in a performant and cost-effective manner. You can read more in the project repository at http://bit.ly/2HCN8gB - please open an issue there if you have questions or would like to get involved. Thanks to all those who have been helping so far!}
    HeartbeatMailer.mentor_heartbeat(User.first, data, introduction)
  end
end

class GenerateMentorHeartbeats
  include Mandate

  def call
    active_mentors.find_each do |mentor|
      email_log = UserEmailLog.for_user(mentor)
      next if email_log.mentor_heartbeat_sent_at.to_i > (Time.current - 6.days).to_i

      if email_log.mentor_heartbeat_sent_at.nil?
        introduction = %Q{Welcome to your first Mentor Heartbeat!\n\nEach week, we'll be sending you an email that summarises the activity on each track you're mentoring. We'll also include information on any changes or updates to the mentoring side of Exercism. If you have any ideas on what you'd like to see here, please open an issue at on GitHub and let us know your thoughts. If you want to opt out, there's a link at the bottom of the email. Finally I just want to say a huge thank you for your hard work and for the thousands of people you're all helping on Exercism!}
      else
        introduction = %Q{This week I want to draw attention to the Track Anatomy Project - the work Maud and our maintainers are doing in restructuring tracks to make them more enjoyable to work through and easier to mentor. Our initial testbed has been Ruby, where we've seen a reduction in the average time-to-mentor from days to only a couple of hours. The maintainers of C#, JavaScript, Rust, Python, Haskell, Elixir and Prolog are all working on implementing Maud's work on their tracks too, so if you mentor those tracks, you should start to notice an improvement in your mentoring experience over the coming weeks. Thank you to everyone involved!\n\nHere are this weeks mentoring stats:}
      end

      merged_tracks_stats = {}
      mentor_tracks_stats = generate_mentor_tracks_stats(mentor)
      mentor_tracks_stats.each do |slug, personal_stats|
        track_stats = tracks_stats[slug][:stats]
        merged_tracks_stats[slug] = {
          title: tracks_stats[slug][:title],
          stats: {
            new_solutions_submitted: track_stats[:new_solutions_submitted],
            solutions_submitted_for_mentoring: track_stats[:solutions_submitted_for_mentoring],
            total_solutions_mentored: track_stats[:total_solutions_mentored],
            solutions_mentored_by_you: mentor_tracks_stats[slug][:solutions_mentored_by_you],
            current_queue_length: track_stats[:current_queue_length],
          }
        }
      end
      next if merged_tracks_stats.empty?

      num_solutions_mentored_by_user = SolutionMentorship.where(user: mentor).
                                         where("solution_mentorships.created_at >= ?", stats_time).
                                         count

      DeliverEmail.(
        mentor,
        :mentor_heartbeat,
        {
          site: site_stats,
          tracks: merged_tracks_stats,
          num_solutions_mentored_by_user: num_solutions_mentored_by_user
        },
        introduction
      )
    end
  end

  private

  def generate_mentor_tracks_stats(mentor)
    tracks = Track.where(id: TrackMentorship.where(user: mentor).select(:track_id))
    track_counts = SolutionMentorship.where(user: mentor).
                                      where("solution_mentorships.created_at >= ?", stats_time).
                                      joins(solution: :exercise).
                                      group('exercises.track_id').count

    tracks.each_with_object(Hash.new{|h,k|h[k] = {}}) do |track, data|
      data[track.slug][:solutions_mentored_by_you] = track_counts[track.id].to_i
    end
  end

  memoize
  def site_stats
    num_solutions = submitted_solution_ids.size
    num_solutions_for_mentoring = Solution.where(id: submitted_solution_ids).
                                           where.not(mentoring_requested_at: nil).
                                           count

    num_solution_mentorships = SolutionMentorship.where("created_at >= ?", stats_time).count

    num_learners = Solution.where(id: submitted_solution_ids).
                            select(:user_id).
                            distinct.count

    num_mentors = Solution.where("last_updated_by_mentor_at >= ?", stats_time).
                                        joins(:mentorships).
                                        select('solution_mentorships.user_id').
                                        distinct.count

    {
      num_solutions: num_solutions,
      num_solutions_for_mentoring: num_solutions_for_mentoring,
      num_solution_mentorships: num_solution_mentorships,
      num_learners: num_learners,
      num_mentors: num_mentors
    }
  end

  memoize
  def tracks_stats
    Track.all.each_with_object({}) do |track, stats|
      track_solutions = Solution.where(id: submitted_solution_ids).
                                    joins(:exercise).where('exercises.track_id': track.id)

      num_solutions = track_solutions.size
      num_solutions_for_mentoring = track_solutions.where.not(mentoring_requested_at: nil).count
      num_solution_mentorships = SolutionMentorship.where("solution_mentorships.created_at >= ?", stats_time).
                                                    joins(solution: :exercise).
                                                    where('exercises.track_id': track.id).
                                                    count

      current_queue_length = Solution.joins(:exercise).where('exercises.track_id': track.id).
                                      submitted.
                                      where.not(mentoring_requested_at: nil).
                                      where(approved_by: nil).
                                      where(completed_at: nil).
                                      where(num_mentors: 0).
                                      count

      stats[track.slug] = {
        title: track.title,
        stats: {
          new_solutions_submitted: num_solutions,
          solutions_submitted_for_mentoring: num_solutions_for_mentoring,
          current_queue_length: current_queue_length,
          total_solutions_mentored: num_solution_mentorships
        }
      }
    end
  end

  def stats_time
    Time.current - 1.week
  end

  def active_mentors
    User.where(id: SolutionMentorship.
                     where("created_at > ?", Time.current - 60.days).
                     select(:user_id).distinct)
  end

  memoize
  def submitted_solution_ids
    Iteration.
      where('created_at >= ?', stats_time).
      where("NOT EXISTS(
               SELECT NULL
               FROM iterations as old_iterations
               WHERE old_iterations.solution_id = iterations.solution_id
               AND created_at < ?
             )", stats_time).
       select(:solution_id).distinct
  end
end

=begin
  * Total number of mentored solutions in total
  * Total number of mentored solutions by me
  * Total number of mentors that have mentored solutions
  * Total number of new submissions per exercise
  * Total number of mentored submissions per exercise
  * Maybe something like average wait time for mentoring per exercise?
  * Maybe average number of iterations before approval per exercise?
  * Total number of solutions
  * Number of core solutions
  * Number of side exercise solutions
  * Mentor rate of core solutions vs side solutions
=end

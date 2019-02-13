module WidgetsHelper
  def maintainer_widget(maintainer)
    cache_widget("maintainer", maintainer) do
      render("widgets/maintainer", maintainer: maintainer)
    end
  end

  def mentor_widget(mentor)
    cache_widget("mentor", mentor) do
      render("widgets/mentor", mentor: mentor)
    end
  end

  def contributor_widget(contributor)
    cache_widget("contributor", contributor) do
      render("widgets/contributor", contributor: contributor)
    end
  end

  def cache_widget(key, object, &block)
    cache_key = "helpers/widgets/#{key}_#{object.id}_#{object.updated_at}"
    Rails.cache.fetch(cache_key) do
      block.call
    end
  end

  def iterations_nav_widget(scope, solution, current_iteration, url_path: nil)
    iteration_ids = solution.iterations.reorder('id asc').pluck(:id)
    num_comments = DiscussionPost.where(iteration_id: iteration_ids).
                                  group(:iteration_id).
                                  count

    current_idx = iteration_ids.index(current_iteration.id) + 1

    render "widgets/iteration_nav", url_parts: [scope, solution],
                                      iteration_ids: iteration_ids,
                                      num_comments: num_comments,
                                      current_idx: current_idx,
                                      url_path: url_path
  end

  def discussion_post_widget(post, solution, user_track, redact_user: false)
    if post.user_id == User::SYSTEM_USER_ID
      render "widgets/system_discussion_post", post: post
    else
      render "widgets/discussion_post", post: post,
                                        solution: solution,
                                        user_track: user_track,
                                        redact_user: redact_user
    end
  end

  def solution_comment_widget(comment, solution)
    user_track = comment.user_id == solution.user_id ?
      solution.user.user_track_for(solution.exercise.track) :
      nil

    render "widgets/solution_comment", comment: comment,
                                       solution: solution,
                                       user_track: user_track
  end
end

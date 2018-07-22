module SolutionsHelper
  def iteration_path(url_path, url_parts)
    if url_path
      send url_path, *url_parts
    else
      url_parts
    end
  end

  def iterations_nav_widget(scope, solution, current_iteration, url_path: nil)
    iteration_ids = solution.iterations.reorder('id asc').pluck(:id)
    num_comments = DiscussionPost.where(iteration_id: iteration_ids).
                                  group(:iteration_id).
                                  count

    current_idx = iteration_ids.index(current_iteration.id) + 1
    p iteration_ids 
    p current_iteration.id
    p current_idx

    render "solutions/iteration_nav", url_parts: [scope, solution],
                                      iteration_ids: iteration_ids,
                                      num_comments: num_comments,
                                      current_idx: current_idx,
                                      url_path: url_path

  end
end

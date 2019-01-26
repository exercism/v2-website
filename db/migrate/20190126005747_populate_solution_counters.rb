class PopulateSolutionCounters < ActiveRecord::Migration[5.2]
  def change
    SolutionStar.group(:solution_id).count.each do |(solution_id, num_stars)|
      Solution.where(id: solution_id).update_all(num_stars: num_stars)
    end

    SolutionComment.group(:solution_id).count.each do |(solution_id, num_comments)|
      Solution.where(id: solution_id).update_all(num_comments: num_comments)
    end
  end
end

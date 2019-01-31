class MigrateReactionsIntoComments < ActiveRecord::Migration[5.2]
  def change
    # This should be run manually on production
    # and takes a long time on development with a legacy db
    return

    LegacyReaction.where.not(comment: nil).find_each do |reaction|
      begin
        SolutionComment.create!(
          solution_id: reaction.solution_id,
          user_id: reaction.user_id,
          content: reaction.comment,
          html: ParseMarkdown.(reaction.comment),
          created_at: reaction.created_at,
          updated_at: reaction.updated_at
        )
      rescue => e
        p "Failed to create solution comment"
        p "  #{e.class.name}"
        p "  #{e.message}"
      end
    end

    LegacyReaction.includes(:solution).find_each do |reaction|
      next if reaction.user_id == reaction.solution.user_id

      begin
        SolutionStar.create!(
          user_id: reaction.user_id,
          solution_id: reaction.solution_id,
          created_at: reaction.created_at,
          updated_at: reaction.updated_at
        )
      rescue => e
        p "Failed to create solution star"
        p "  #{e.class.name}"
        p "  #{e.message}"
      end
    end

    SolutionStar.group(:solution_id).count.each do |(solution_id, num_stars)|
      Solution.where(id: solution_id).update_all(num_stars: num_stars)
    end

    SolutionComment.group(:solution_id).count.each do |(solution_id, num_comments)|
      Solution.where(id: solution_id).update_all(num_comments: num_comments)
    end
  end
end

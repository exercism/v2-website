class MigrateReactionsIntoComments < ActiveRecord::Migration[5.2]
  def change
    # This should be run manually on production
    # and takes *forever* on development with a legacy db
    return

    Reaction.where.not(comment: nil).find_each do |reaction|
      SolutionComment.create!(
        solution_id: reaction.solution_id,
        user_id: reaction.user_id,
        content: reaction.comment,
        html: ParseMarkdown.(reaction.comment),
        created_at: reaction.created_at,
        updated_at: reaction.updated_at
      )
    end
    Reaction.where(emotion: :legacy).delete_all
  end
end

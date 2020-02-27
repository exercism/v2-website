class AddNullCheckToSyntaxHighlighterColumn < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tracks, :syntax_highlighter_language, false
  end
end

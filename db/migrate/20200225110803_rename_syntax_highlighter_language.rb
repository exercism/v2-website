class RenameSyntaxHighlighterLanguage < ActiveRecord::Migration[6.0]
  def change
    add_column :tracks, :syntax_highlighter_language, :string

    Track.update_all("syntax_highlighter_language = syntax_highligher_language")
  end
end

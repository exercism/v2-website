module FileHelper
  def syntax_highlighter_for_filename(filename, track)
    parts = filename.split(".")

    lang = parts.size > 1 ?
      Exercism::PrismFileMappings[parts.last.downcase] :
      track.syntax_highligher_language

    "language-#{lang}"
  end
end

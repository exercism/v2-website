module FileHelper
  def syntax_highlighter_for_filename(filename, track)
    parts = filename.split(".")

    if !parts.empty?
      extension = parts.last.downcase
      lang = Exercism::PrismFileMappings[extension]
    end

    lang ||= track.syntax_highligher_language

    "language-#{lang}"
  end
end

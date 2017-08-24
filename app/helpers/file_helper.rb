module FileHelper
  def syntax_highlighter_for_filename(filename, track)
    parts = filename.split(".")
    ext = parts.size == 1 ? nil : parts.last
    p ext

    lang = case ext
      when "rb"
        "ruby"
      when "go"
        "go"
      when "txt"
        "plain"
      else
        track.syntax_highligher_language
      end

    "language-#{lang}"
  end
end

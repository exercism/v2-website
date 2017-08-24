module FileHelper
  def syntax_highlighter_for_filename(filename, track)
    parts = filename.split(".")
    ext = parts.size == 1 ? nil : parts.last

    lang = Exercism::PrismFileMappings[ext]
    "language-#{lang}"
  end
end

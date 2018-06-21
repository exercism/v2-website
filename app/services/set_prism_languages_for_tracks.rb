class SetPrismLanguagesForTracks
  include Mandate

  def call
    Track.all.each do |track|
      prism_language = track.slug
      unless Exercism::PrismLanguages.include?(prism_language)
        if mapping = Exercism::PrismLanguageMappings[prism_language]
          prism_language = mapping
        else
          p "Warning: #{track.slug} is not a Prism Language"
        end
      end

      track.update(syntax_highligher_language: prism_language)
    end
  end
end


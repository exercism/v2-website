module Research
  class ExerciseSlug
    FORMAT = "%{language}-%{part}-%{exercise}"

    def self.construct(language:, part:, exercise:)
      FORMAT % { language: language, part: part, exercise: exercise }
    end

    def self.deconstruct(slug)
      {
        language: slug.split("-").tap{ |s| s.pop(2) }.join('-').to_sym
      }
    end
  end
end

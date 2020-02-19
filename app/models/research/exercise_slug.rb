module Research
  class ExerciseSlug
    FORMAT = "%{language}-%{part}-%{exercise}"

    def self.construct(language:, part:, exercise:)
      FORMAT % { language: language, part: part, exercise: exercise }
    end

    def self.deconstruct(slug)
      bits = slug.split("-")
      exercise = bits.pop
      part = bits.pop
      language = bits.join('-').to_sym
      {
        language: language,
        part: part,
        exericse: exercise
      }
    end
  end
end

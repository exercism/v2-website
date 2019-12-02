module Research
  class SolutionSlug
    FORMAT = "%{language}-%{exercise}-%{part}"

    def self.construct(language:, part:, exercise:)
      FORMAT % { language: language, exercise: exercise, part: part }
    end

    def self.deconstruct(slug)
      {
        language: slug.split("-").tap{ |s| s.pop(2) }.join('-').to_sym
      }
    end
  end
end

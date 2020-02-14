module Git
  class ExerciseConfig
    def self.from_file(data)
      new(JSON.parse(data).with_indifferent_access)
    end

    attr_reader :data
    def initialize(data)
      @data = data
    end

    def tests_info
      Git::TestsInfo.new(data[:tests])
    end
  end
end

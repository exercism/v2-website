module Git
  class ExerciseConfig
    def self.from_file(file)
      new(JSON.parse(file).with_indifferent_access)
    end

    attr_reader :data
    def initialize(data)
      @data = data
    end

    def test_messages
      Array(data[:test_messages]).
        map { |message| Git::TestMessage.from_file(message) }
    end

    def solution_files
      filepaths = data[:solution_files]

      files = exercise_files(false).select do |f|
        f[:type] == :blob && filepaths.include?(f[:full])
      end

      files.each_with_object({}) do |file, h|
        h[file[:name]] = read_blob(file[:oid])
      end
    rescue => e
      Bugsnag.notify(e)
      {}
    end
  end
end

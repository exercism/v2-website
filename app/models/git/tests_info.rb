require "ostruct"

module Git
  class TestsInfo < SimpleDelegator
    def initialize(tests)
      super(tests.to_a.map { |test| OpenStruct.new(test) })
    end

    def reorder(tests)
      reject { |info| info.cmd.blank? }.
        map { |info| tests.find { |test| info.test == test.test } }.
      compact
    end
  end
end

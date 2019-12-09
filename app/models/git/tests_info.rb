module Git
  class TestsInfo < SimpleDelegator
    def initialize(tests)
      super(Array(tests).map { |test| TestInfo.new(test) })
    end

    def reorder(tests)
      tests_info.
        map { |info| tests.find { |test| info.name == test.name } }.
        compact
    end

    private

    def tests_info
      __getobj__
    end

    TestInfo = Struct.new(:name, :cmd, :msg, keyword_init: true)
  end
end

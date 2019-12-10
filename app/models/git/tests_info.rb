module Git
  class TestsInfo < SimpleDelegator
    def initialize(tests)
      super(tests.to_a.map { |test| TestInfo.new(test) })
    end

    def reorder(tests)
      reject { |info| info.cmd.blank? }.
      map { |info| tests.find { |test| info.name == test.name } }.
      compact
    end

    private

    TestInfo = Struct.new(:name, :cmd, :msg, keyword_init: true)
  end
end

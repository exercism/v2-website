require 'test_helper'

module Flux
  class MergeJSandECMATest < ActiveSupport::TestCase
    setup do
      @js = create :track, slug: "javascript"
      @ecma = create :track, slug: "ecmascript"
      @ruby = create :track, slug: "ruby"

      @js_hamming = create :exercise, slug: 'hamming', track: @js
      @ecma_hamming = create :exercise, slug: 'hamming', track: @ecma
      @ruby_hamming = create :exercise, slug: 'hamming', track: @ruby
      @js_bob = create :exercise, slug: 'bob', track: @js
      @ecma_bob = create :exercise, slug: 'bob', track: @ecma
      @ruby_bob = create :exercise, slug: 'bob', track: @ruby
    end

    test "JS Sha is correct" do
      assert_equal "6a8a5a41b89a45008b46ca18ff7ea800baca1c4c", MergeJSAndECMA::JS_SHA
    end

    test "migrates the solutions correctly" do
      Timecop.freeze do

        js_bob_solution = create :solution, exercise: @js_bob
        ecma_bob_solution = create :solution, exercise: @ecma_bob
        ruby_bob_solution = create :solution, exercise: @ruby_bob

        js_hamming_solution = create :solution, exercise: @js_hamming
        ecma_hamming_solution = create :solution, exercise: @ecma_hamming
        ruby_hamming_solution = create :solution, exercise: @ruby_hamming

        MergeJSAndECMA.()

        [
          js_bob_solution, ecma_bob_solution, ruby_bob_solution,
          js_hamming_solution, ecma_hamming_solution, ruby_hamming_solution
        ].each(&:reload)

        # Check JS has changed
        assert_equal @ecma_bob, js_bob_solution.exercise
        assert_equal @ecma_hamming, js_hamming_solution.exercise

        # Check ecma is unchanged
        assert_equal @ecma_bob, ecma_bob_solution.exercise
        assert_equal @ecma_hamming, ecma_hamming_solution.exercise

        # Check Ruby is unchanged
        assert_equal @ruby_bob, ruby_bob_solution.exercise
        assert_equal @ruby_hamming, ruby_hamming_solution.exercise
      end
    end

    test "locks the JS Sha" do
      ecma_sha = SecureRandom.uuid

      js_bob_solution = create :solution, exercise: @js_bob, git_sha: SecureRandom.uuid
      ecma_bob_solution = create :solution, exercise: @ecma_bob, git_sha: ecma_sha

      MergeJSAndECMA.()

      [js_bob_solution, ecma_bob_solution].each(&:reload)

      assert_equal MergeJSAndECMA::JS_SHA, js_bob_solution.git_sha
      assert_equal ecma_sha, ecma_bob_solution.git_sha
    end
  end
end

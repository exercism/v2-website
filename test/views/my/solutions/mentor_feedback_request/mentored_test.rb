require "test_helper"

module My
  module Solutions
    module MentorFeedbackRequest
      class MentoredTest < ActionView::TestCase
        test "renders partial for oversubscribed tracks" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :oversubscribed
          )
          render "my/solutions/mentor_feedback_request/mentored",
            mentor_request: mentor_request

          assert_match "Request mentor feedback (disabled)", rendered
          assert_match "This track is currently oversubscribed", rendered
        end

        test "renders partial for exercises promoted to core" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :promoted_to_core
          )
          render "my/solutions/mentor_feedback_request/mentored",
            mentor_request: mentor_request

          assert_select "a", text: "Request mentor feedback"
          assert_match(
            "This exercise has been promoted to a core exercise.",
            rendered
          )
        end

        test "renders partial for mentoring slots used" do
          solution = stub(track_max_mentoring_slots: 0,
                          track_mentoring_slots_remaining: 0)
          mentor_request = ::MentorFeedbackRequest.new(
            solution,
            status: :mentoring_slots_used
          )
          render "my/solutions/mentor_feedback_request/mentored",
            mentor_request: mentor_request

          assert_match "Request mentor feedback (disabled)", rendered
          assert_match(
            "Once your existing non-core solutions have been mentored",
            rendered
          )
        end

        test "renders partial for mentoring slots remaining" do
          solution = stub(track_max_mentoring_slots: 3,
                          track_mentoring_slots_remaining: 3)
          mentor_request = ::MentorFeedbackRequest.new(
            solution,
            status: :mentoring_slots_remaining
          )
          render "my/solutions/mentor_feedback_request/mentored",
            mentor_request: mentor_request

          assert_select "a", text: "Request mentor feedback"
          assert_match "You have 3 slots remaining", rendered
        end
      end
    end
  end
end

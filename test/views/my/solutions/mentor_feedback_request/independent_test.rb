require "test_helper"

module My
  module Solutions
    module MentorFeedbackRequest
      class IndependentTest < ActionView::TestCase
        test "renders partial for oversubscribed tracks" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :oversubscribed
          )
          render "my/solutions/mentor_feedback_request/independent",
            mentor_request: mentor_request

          assert_match "Request mentor feedback (disabled)", rendered
          assert_match "This track is currently oversubscribed", rendered
        end

        test "renders partial for mentoring slots used" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :mentoring_slots_used
          )
          render "my/solutions/mentor_feedback_request/independent",
            mentor_request: mentor_request

          assert_match "Request mentor feedback (disabled)", rendered
          assert_match(
            "Mentoring is disabled by default in Practice Mode.",
            rendered
          )
          assert_match "You currently have no slots free.", rendered
        end

        test "renders partial for mentoring slots remaining" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :mentoring_slots_remaining
          )
          render "my/solutions/mentor_feedback_request/independent",
            mentor_request: mentor_request

          assert_select "a", text: "Request mentor feedback"
          assert_match(
            "Mentoring is disabled by default in Practice Mode.",
            rendered
          )
        end
      end
    end
  end
end

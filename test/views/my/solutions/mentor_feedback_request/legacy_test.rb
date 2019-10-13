require "test_helper"

module My
  module Solutions
    module MentorFeedbackRequest
      class LegacyTest < ActionView::TestCase
        test "renders partial for oversubscribed tracks" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :oversubscribed
          )

          render "my/solutions/mentor_feedback_request/legacy",
            mentor_request: mentor_request

          assert_match "Request mentor feedback (disabled)", rendered
          assert_match "This track is currently oversubscribed", rendered
        end

        test "renders partial for mentoring slots used" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :mentoring_slots_used
          )

          render "my/solutions/mentor_feedback_request/legacy",
            mentor_request: mentor_request

          assert_match "Request mentor feedback (disabled)", rendered
          assert_match(
            "This solution has been imported from Practice Mode.",
            rendered
          )
        end

        test "renders partial for mentoring slots remaining" do
          mentor_request = ::MentorFeedbackRequest.new(
            create(:solution),
            status: :mentoring_slots_remaining
          )

          render "my/solutions/mentor_feedback_request/legacy",
            mentor_request: mentor_request

          assert_select "a", text: "Request mentor feedback"
          assert_match(
            "This solution has been imported from an old version of the website",
            rendered
          )
        end
      end
    end
  end
end

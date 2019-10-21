require 'test_helper'

class MentorFeedbackRequestHelperTest < ActionView::TestCase
  test "renders partial for oversubscribed tracks in independent mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :oversubscribed
    )

    render_solution_mentor_feedback_request_section(
      :independent,
      nil,
      mentor_request
    )

    assert_match "Request mentor feedback (disabled)", rendered
    assert_match "This track is currently oversubscribed", rendered
  end

  test "renders partial for mentoring slots used in independent mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :mentoring_slots_used
    )

    render_solution_mentor_feedback_request_section(
      :independent,
      nil,
      mentor_request
    )

    assert_match "Request mentor feedback (disabled)", rendered
    assert_match(
      "Mentoring is disabled by default in Practice Mode.",
      rendered
    )
    assert_match "You currently have no slots free.", rendered
  end

  test "renders partial for mentoring slots remaining in independent mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :mentoring_slots_remaining
    )

    render_solution_mentor_feedback_request_section(
      :independent,
      nil,
      mentor_request
    )

    assert_select "a", text: "Request mentor feedback"
    assert_match(
      "Mentoring is disabled by default in Practice Mode.",
      rendered
    )
  end

  test "renders partial for oversubscribed tracks in legacy mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :oversubscribed
    )

    render_solution_mentor_feedback_request_section(
      :legacy,
      nil,
      mentor_request
    )

    assert_match "Request mentor feedback (disabled)", rendered
    assert_match "This track is currently oversubscribed", rendered
  end

  test "renders partial for mentoring slots used in legacy mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :mentoring_slots_used
    )

    render_solution_mentor_feedback_request_section(
      :legacy,
      nil,
      mentor_request
    )

    assert_match "Request mentor feedback (disabled)", rendered
    assert_match(
      "This solution has been imported from Practice Mode.",
      rendered
    )
  end

  test "renders partial for mentoring slots remaining in legacy mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :mentoring_slots_remaining
    )

    render_solution_mentor_feedback_request_section(
      :legacy,
      nil,
      mentor_request
    )

    assert_select "a", text: "Request mentor feedback"
    assert_match(
      "This solution has been imported from an old version of the website",
      rendered
    )
  end

  test "renders partial for oversubscribed tracks in mentored mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :oversubscribed
    )

    render_solution_mentor_feedback_request_section(
      :mentored,
      nil,
      mentor_request
    )

    assert_match "Request mentor feedback (disabled)", rendered
    assert_match "This track is currently oversubscribed", rendered
  end

  test "renders partial for exercises promoted to core in mentored mode" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :promoted_to_core
    )

    render_solution_mentor_feedback_request_section(
      :mentored,
      nil,
      mentor_request
    )

    assert_select "a", text: "Request mentor feedback"
    assert_match(
      "This exercise has been promoted to a core exercise.",
      rendered
    )
  end

  test "renders partial for mentoring slots used in mentored mode" do
    solution = stub(track_max_mentoring_slots: 0,
                    track_mentoring_slots_remaining: 0)
    mentor_request = ::MentorFeedbackRequest.new(
      solution,
      status: :mentoring_slots_used
    )

    render_solution_mentor_feedback_request_section(
      :mentored,
      nil,
      mentor_request
    )

    assert_match "Request mentor feedback (disabled)", rendered
    assert_match(
      "Once your existing non-core solutions have been mentored",
      rendered
    )
  end

  test "renders partial for mentoring slots remaining in mentored mode" do
    solution = stub(track_max_mentoring_slots: 3,
                    track_mentoring_slots_remaining: 3)
    mentor_request = ::MentorFeedbackRequest.new(
      solution,
      status: :mentoring_slots_remaining
    )

    render_solution_mentor_feedback_request_section(
      :mentored,
      nil,
      mentor_request
    )

    assert_select "a", text: "Request mentor feedback"
    assert_match "You have 3 slots remaining", rendered
  end

  test "renders notification for oversubscribed tracks" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :oversubscribed
    )

    render_mentor_feedback_request_notification(
      nil,
      mentor_request
    )

    assert_match(
      "You may request mentoring once the track isn't oversubscribed.",
      rendered
    )
  end

  test "renders notification for mentoring slots used" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :mentoring_slots_used
    )

    render_mentor_feedback_request_notification(
      nil,
      mentor_request
    )

    assert_match(
      "You may request mentoring once your existing solutions have been mentored.",
      rendered
    )
  end

  test "renders notification for mentoring slots remaining" do
    mentor_request = ::MentorFeedbackRequest.new(
      create(:solution),
      status: :mentoring_slots_remaining
    )

    render_mentor_feedback_request_notification(
      nil,
      mentor_request
    )

    assert_select "a", text: "Request mentoring"
    assert_match(
      "You may request mentoring on one solution at a time.",
      rendered
    )
  end
end

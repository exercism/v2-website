class Mentor::DiscussionPostsController < MentorController
  def create
    @iteration = Iteration.find(params[:iteration_id])

    return head 403 unless current_user.mentoring_track?(@iteration.solution.exercise.track)
    @post = CreatesMentorDiscussionPost.create!(@iteration, current_user, params[:discussion_post][:content])
  end
end

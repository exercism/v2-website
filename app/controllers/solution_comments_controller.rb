class SolutionCommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :check_if_allowed_to_comment!, only: [:create]

  def show
    solution = Solution.find_by_uuid!(params[:solution_id])
    comment = solution.comments.find(params[:id])
    redirect_to solution_path(solution, anchor: "solution-comment-#{comment.id}")
  end

  def create
    @solution = Solution.find_by_uuid!(params[:solution_id])
    @comment = CreateSolutionComment.(@solution, current_user, params[:solution_comment][:content])
  end

  def update
    @comment = current_user.solution_comments.find(params[:id])
    @solution = @comment.solution

    @comment.update!(
      previous_content: [@comment.previous_content, @comment.content].compact.join("\n---\n"),
      content: solution_comment_params[:content],
      html: ParseMarkdown.(solution_comment_params[:content]),
      edited: true
    )
  end

  def destroy
    @comment = current_user.solution_comments.find(params[:id])
    @solution = @comment.solution
    @comment.update!(deleted: true)
  end

  private

  def check_if_allowed_to_comment!
    unless AllowedToCommentPolicy.allowed?(current_user)
      head :unprocessable_entity
    end
  end

  def solution_comment_params
    params.require(:solution_comment).permit(:content)
  end
end

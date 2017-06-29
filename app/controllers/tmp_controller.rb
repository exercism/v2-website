class TmpController < ApplicationController
  def create_iteration
    @solution = current_user.solutions.find(params[:solution_id])
    CreatesIteration.create!(@solution, "class Foobar\n  def barfoo\n  end\nend")
    redirect_to @solution
  end
end


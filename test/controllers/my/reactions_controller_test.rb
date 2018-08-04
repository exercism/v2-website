require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  test "create creates" do
    sign_in!
    solution = create :solution, published_at: DateTime.now
    post my_reactions_path, params: {solution_id: solution.uuid, emotion: "love", format: 'js'}

    assert_response :success
    assert_equal 1, solution.reactions.size
    reaction = solution.reactions.first

    assert_equal @current_user, reaction.user
    assert_equal "love", reaction.emotion
  end

  test "create updates" do
    sign_in!
    solution = create :solution, published_at: DateTime.now
    reaction = create :reaction, solution: solution, user: @current_user, emotion: 'like'
    post my_reactions_path, params: {solution_id: solution.uuid, emotion: "love", format: 'js'}

    assert_response :success
    assert_equal 1, solution.reactions.size
    reaction = solution.reactions.first

    assert_equal @current_user, reaction.user
    assert_equal "love", reaction.emotion
  end

  test "create destroys" do
    sign_in!
    solution = create :solution, published_at: DateTime.now
    reaction = create :reaction, solution: solution, user: @current_user, emotion: 'love', comment: nil
    post my_reactions_path, params: {solution_id: solution.uuid, emotion: "love", format: 'js'}

    assert_response :success
    assert_equal 0, Reaction.where(solution: solution).size
  end

  test "create does not destroy when comment is present" do
    sign_in!
    comment = "foobar"
    solution = create :solution, published_at: DateTime.now
    reaction = create :reaction, solution: solution, user: @current_user, emotion: 'love', comment: comment
    post my_reactions_path, params: {solution_id: solution.uuid, emotion: "love", format: 'js'}

    assert_response :success
    assert_equal 1, solution.reactions.size
    reaction = solution.reactions.first

    assert_equal @current_user, reaction.user
    assert_equal comment, reaction.comment
    assert_equal "love", reaction.emotion
  end

  test "index only shows published solutions" do
    sign_in!
    published_solution = create :solution, published_at: DateTime.now
    unpublished_solution = create :solution
    create :reaction, solution: published_solution, user: @current_user
    create :reaction, solution: unpublished_solution, user: @current_user

    get my_reactions_path
    assert_equal [published_solution], assigns(:solutions)
  end
end

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "name is set if unset" do
    topic = Topic.create(slug: "cat_and_mat")
    assert_equal "Cat And Mat", topic.name
  end
  test "name isn't set if set" do
    name = "The Mouse"
    topic = Topic.create(slug: "cat_and_mat", name: name)
    assert_equal name, topic.name
  end
end

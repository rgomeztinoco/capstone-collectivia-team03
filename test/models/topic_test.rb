require "test_helper"

class TopicTest < ActiveSupport::TestCase
  test "should not save topic without name" do
    topic = Topic.new
    assert_not(topic.save, "expected to not save topic without name")
  end

  test "should not save topic with duplicated name" do
    topic_in_db = topics(:one)
    topic = Topic.new(name: topic_in_db.name)
    assert_not(topic.save, "expected to not save topic with duplicated name")
  end

  test "can save valid topic" do
    topic = Topic.new(name: "Valid Topic")
    assert(topic.save, "expected to be able to save valid topic")
  end
end

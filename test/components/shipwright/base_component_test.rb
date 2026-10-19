require "test_helper"

# Test subclass to exercise the private `classes` helper
class TestComponent < Shipwright::BaseComponent
  def test_classes(...)
    classes(...)
  end
end

class Shipwright::BaseComponentTest < ActiveSupport::TestCase
  setup do
    @component = TestComponent.new
  end

  def test_merges_default_classes
    result = @component.test_classes("px-4 py-2", "bg-interactive-primary-default text-text-inverse")
    assert_includes result, "px-4"
    assert_includes result, "bg-interactive-primary-default"
  end

  def test_consumer_override_wins
    result = @component.test_classes("bg-interactive-primary-default text-text-inverse", consumer: "bg-red-500")
    assert_includes result, "bg-red-500"
    refute_includes result, "bg-interactive-primary-default"
  end

  def test_conditionals_applied_when_true
    result = @component.test_classes("px-4", "opacity-50": true)
    assert_includes result, "opacity-50"
  end

  def test_conditionals_skipped_when_false
    result = @component.test_classes("px-4", "opacity-50": false)
    refute_includes result, "opacity-50"
  end

  def test_consumer_wins_over_conditionals
    result = @component.test_classes("px-4", "opacity-50": true, consumer: "opacity-100")
    assert_includes result, "opacity-100"
    refute_includes result, "opacity-50"
  end

  def test_handles_nil_consumer
    result = @component.test_classes("px-4 bg-interactive-primary-default", consumer: nil)
    assert_includes result, "px-4"
    assert_includes result, "bg-interactive-primary-default"
  end

  def test_handles_empty_string_consumer
    result = @component.test_classes("px-4", consumer: "")
    assert_includes result, "px-4"
  end

  def test_custom_theme_tokens_conflict_correctly
    result = @component.test_classes("bg-interactive-primary-default", consumer: "bg-utility-negative-default")
    assert_includes result, "bg-utility-negative-default"
    refute_includes result, "bg-interactive-primary-default"
  end
end

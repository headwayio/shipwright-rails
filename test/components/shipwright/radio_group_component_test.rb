require "test_helper"

class Shipwright::RadioGroupComponentTest < ViewComponent::TestCase
  def test_renders_fieldset_and_legend
    render_inline(Shipwright::RadioGroupComponent.new(name: "plan", label: "Plan"))

    assert_selector "fieldset legend", text: "Plan"
  end

  def test_required_marker
    render_inline(Shipwright::RadioGroupComponent.new(name: "plan", label: "Plan", required: true))

    assert_text "(required)"
  end

  def test_no_required_marker_when_not_required
    render_inline(Shipwright::RadioGroupComponent.new(name: "plan", label: "Plan"))

    refute_includes rendered_content, "(required)"
  end

  def test_renders_option_radios_sharing_name
    render_inline(Shipwright::RadioGroupComponent.new(name: "plan")) do |g|
      g.with_option(value: "free", label: "Free")
      g.with_option(value: "pro", label: "Pro", checked: true)
      g.with_option(value: "team", label: "Team")
    end

    assert_selector "input[type='radio'][name='plan']", count: 3, visible: :all
    assert_selector "input[value='free']", visible: :all
    assert_selector "input[value='pro'][checked]", visible: :all
    assert_selector "input[value='team']", visible: :all
  end

  def test_vertical_layout_uses_column_classes
    render_inline(Shipwright::RadioGroupComponent.new(name: "x", layout: :vertical)) do |g|
      g.with_option(value: "a", label: "A")
    end

    assert_includes rendered_content, "flex-col"
  end

  def test_horizontal_layout_uses_row_classes
    render_inline(Shipwright::RadioGroupComponent.new(name: "x", layout: :horizontal)) do |g|
      g.with_option(value: "a", label: "A")
    end

    assert_includes rendered_content, "flex-row"
  end

  def test_option_caption_forwarded
    render_inline(Shipwright::RadioGroupComponent.new(name: "x")) do |g|
      g.with_option(value: "a", label: "A", caption: "Most popular")
    end

    assert_text "Most popular"
  end

  def test_option_disabled_forwarded
    render_inline(Shipwright::RadioGroupComponent.new(name: "x")) do |g|
      g.with_option(value: "a", label: "A", disabled: true)
    end

    assert_selector "input[disabled]", visible: :all
  end

  def test_raises_on_invalid_layout
    assert_raises(ArgumentError) do
      Shipwright::RadioGroupComponent.new(name: "x", layout: :grid)
    end
  end

  def test_consumer_class_merges_on_fieldset
    render_inline(Shipwright::RadioGroupComponent.new(name: "x", class: "my-8"))

    assert_selector "fieldset.my-8"
  end
end

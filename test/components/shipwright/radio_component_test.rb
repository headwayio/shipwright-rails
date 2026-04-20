require "test_helper"

class Shipwright::RadioComponentTest < ViewComponent::TestCase
  def test_renders_label_and_input
    render_inline(Shipwright::RadioComponent.new(name: "plan", value: "pro", label: "Pro"))

    assert_selector "input[type='radio'][name='plan'][value='pro']", visible: :all
    assert_text "Pro"
  end

  def test_caption_rendered_with_label
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", label: "Option", caption: "Helper text"))

    assert_text "Helper text"
  end

  def test_checked_state
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", checked: true))

    assert_selector "input[type='radio'][checked]", visible: :all
  end

  def test_disabled_state
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", disabled: true))

    assert_selector "input[type='radio'][disabled]", visible: :all
    assert_includes rendered_content, "cursor-not-allowed"
  end

  def test_id_auto_derived_from_name_and_value
    render_inline(Shipwright::RadioComponent.new(name: "plan", value: "pro"))

    assert_selector "label[for='plan_pro']"
    assert_selector "input[id='plan_pro']", visible: :all
  end

  def test_custom_id_respected
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", id: "my-id"))

    assert_selector "label[for='my-id']"
    assert_selector "input[id='my-id']", visible: :all
  end

  def test_label_position_left_reverses_flex
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", label: "x", label_position: :left))

    assert_includes rendered_content, "flex-row-reverse"
  end

  def test_destructive_variant_applies_negative_color
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", variant: :destructive))

    assert_includes rendered_content, "utility-negative-default"
  end

  def test_size_md_uses_larger_circle
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", size: :md))

    assert_includes rendered_content, "w-6 h-6"
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) do
      Shipwright::RadioComponent.new(name: "p", value: "x", variant: :weird)
    end
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      Shipwright::RadioComponent.new(name: "p", value: "x", size: :huge)
    end
  end

  def test_raises_on_invalid_label_position
    assert_raises(ArgumentError) do
      Shipwright::RadioComponent.new(name: "p", value: "x", label_position: :top)
    end
  end

  def test_consumer_class_merges_on_label
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x", class: "my-8"))

    assert_selector "label.my-8"
  end

  def test_dot_hidden_by_default_shown_when_checked
    render_inline(Shipwright::RadioComponent.new(name: "p", value: "x"))

    # Dot element present but starts hidden; reveal is CSS-driven.
    assert_selector "[aria-hidden='true']"
    assert_includes rendered_content, "group-has-checked:block"
  end
end

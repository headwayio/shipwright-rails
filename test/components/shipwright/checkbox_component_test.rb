require "test_helper"

class Shipwright::CheckboxComponentTest < ViewComponent::TestCase
  def test_renders_input_with_type_checkbox
    render_inline(Shipwright::CheckboxComponent.new(name: "terms", label: "Accept terms"))

    assert_selector "input[type='checkbox'][name='terms']"
  end

  def test_renders_label_text
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "My label"))

    assert_selector "label", text: "My label"
  end

  def test_renders_caption_when_given
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", caption: "Caption text"))

    assert_text "Caption text"
  end

  def test_no_caption_element_when_nil
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L"))

    assert_no_selector "[data-checkbox-caption]"
  end

  def test_checked_attribute
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", checked: true))

    assert_selector "input[type='checkbox'][checked]"
  end

  def test_unchecked_by_default
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L"))

    assert_no_selector "input[type='checkbox'][checked]"
  end

  def test_disabled_attribute
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", disabled: true))

    assert_selector "input[type='checkbox'][disabled]"
    assert_selector "label.cursor-not-allowed"
  end

  def test_indeterminate_sets_data_attribute
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", indeterminate: true))

    # Data attribute for CSS targeting + JS bootstrapping to set input.indeterminate
    assert_selector "label[data-indeterminate='true']"
  end

  def test_destructive_variant_applies_negative_color
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", variant: :destructive, checked: true))

    html = rendered_content
    assert_includes html, "utility-negative-default"
  end

  def test_default_variant_uses_primary_color
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", checked: true))

    html = rendered_content
    assert_includes html, "interactive-primary-default"
  end

  def test_label_position_right_by_default
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L"))

    assert_no_selector "label.flex-row-reverse"
  end

  def test_label_position_left_reverses_order
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", label_position: :left))

    assert_selector "label.flex-row-reverse"
  end

  def test_value_attribute_defaults_to_1
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L"))

    assert_selector "input[value='1']"
  end

  def test_custom_value
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", value: "yes"))

    assert_selector "input[value='yes']"
  end

  def test_auto_generated_id_from_name
    render_inline(Shipwright::CheckboxComponent.new(name: "accept_terms", label: "L"))

    assert_selector "input[id='accept_terms']"
    assert_selector "label[for='accept_terms']"
  end

  def test_custom_id
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", id: "my-check"))

    assert_selector "input[id='my-check']"
    assert_selector "label[for='my-check']"
  end

  def test_check_icon_rendered_in_visual
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L"))

    assert_selector "svg[data-check-icon]"
  end

  def test_dash_icon_rendered_for_indeterminate
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L"))

    assert_selector "svg[data-dash-icon]"
  end

  def test_consumer_class_merges_onto_label
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", class: "my-2"))

    assert_selector "label.my-2"
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) do
      render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", variant: :weird))
    end
  end

  def test_raises_on_invalid_label_position
    assert_raises(ArgumentError) do
      render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", label_position: :top))
    end
  end

  def test_renders_without_label
    render_inline(Shipwright::CheckboxComponent.new(name: "x"))

    assert_selector "input[type='checkbox']"
    # sr-only label for accessibility when no visible label
    assert_no_selector "[data-checkbox-label]"
  end

  def test_passes_html_attributes_to_input
    render_inline(Shipwright::CheckboxComponent.new(name: "x", label: "L", data: { turbo: "false" }))

    assert_selector "input[data-turbo='false']"
  end
end

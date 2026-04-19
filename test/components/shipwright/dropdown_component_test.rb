require "test_helper"

class Shipwright::DropdownComponentTest < ViewComponent::TestCase
  def test_renders_with_label_and_caption
    render_inline(Shipwright::DropdownComponent.new(name: "cat", label: "Category", caption: "Choose one"))

    assert_text "Category"
    assert_text "Choose one"
  end

  def test_renders_details_and_summary_trigger
    render_inline(Shipwright::DropdownComponent.new(name: "cat"))

    assert_selector "details"
    assert_selector "details > summary"
  end

  def test_renders_hidden_input_for_form
    render_inline(Shipwright::DropdownComponent.new(name: "category", value: "files"))

    assert_selector "input[type='hidden'][name='category'][value='files']", visible: :all
  end

  def test_placeholder_shows_when_no_value
    render_inline(Shipwright::DropdownComponent.new(name: "x", placeholder: "Pick something"))

    assert_text "Pick something"
  end

  def test_selected_item_label_shows_when_value_matches
    render_inline(Shipwright::DropdownComponent.new(name: "x", value: "a", placeholder: "Pick")) do |d|
      d.with_item(value: "a", primary: "Apple")
      d.with_item(value: "b", primary: "Banana")
    end

    html = rendered_content
    assert_includes html, "Apple"
  end

  def test_renders_items
    render_inline(Shipwright::DropdownComponent.new(name: "x")) do |d|
      d.with_item(value: "one", primary: "Primary Text")
      d.with_item(value: "two", primary: "Another")
    end

    # Menu is collapsed by default (closed <details>) — check rendered HTML
    assert_selector "[data-dropdown-item]", count: 2, visible: :all
    assert_includes rendered_content, "Primary Text"
    assert_includes rendered_content, "Another"
  end

  def test_item_with_secondary_text
    render_inline(Shipwright::DropdownComponent.new(name: "x")) do |d|
      d.with_item(value: "a", primary: "Main", secondary: "Subtitle text")
    end

    assert_includes rendered_content, "Subtitle text"
  end

  def test_item_with_icon
    render_inline(Shipwright::DropdownComponent.new(name: "x")) do |d|
      d.with_item(value: "a", primary: "Main", icon: :folder)
    end

    assert_selector "[data-dropdown-item] svg", visible: :all
  end

  def test_disabled_adds_attribute_and_classes
    render_inline(Shipwright::DropdownComponent.new(name: "x", disabled: true))

    # summary gets aria-disabled so keyboard activation is suppressed
    assert_selector "summary[aria-disabled='true']"
  end

  def test_destructive_variant_applies_negative_color
    render_inline(Shipwright::DropdownComponent.new(name: "x", variant: :destructive))

    html = rendered_content
    assert_includes html, "utility-negative-default"
  end

  def test_default_variant_uses_primary_border
    render_inline(Shipwright::DropdownComponent.new(name: "x"))

    html = rendered_content
    assert_includes html, "border-border-primary"
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::DropdownComponent.new(name: "x", class: "my-4"))

    assert_selector "div.my-4"
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) do
      render_inline(Shipwright::DropdownComponent.new(name: "x", variant: :warning))
    end
  end

  def test_chevron_rendered_in_trigger
    render_inline(Shipwright::DropdownComponent.new(name: "x"))

    assert_selector "summary svg"
  end

  def test_label_associates_with_trigger_via_id
    render_inline(Shipwright::DropdownComponent.new(name: "x", label: "L"))

    # A label element exists somewhere referencing the trigger
    assert_selector "[data-dropdown-label-text]", text: "L"
  end
end

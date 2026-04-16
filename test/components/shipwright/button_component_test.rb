require "test_helper"

class Shipwright::ButtonComponentTest < ViewComponent::TestCase
  def test_renders_primary_button_by_default
    render_inline(Shipwright::ButtonComponent.new) { "Click me" }

    assert_selector "button", text: "Click me"
    assert_selector "button.bg-interactive-primary-default"
    assert_selector "button.text-text-inverse"
  end

  def test_renders_secondary_hierarchy
    render_inline(Shipwright::ButtonComponent.new(hierarchy: :secondary)) { "Secondary" }

    assert_selector "button.bg-interactive-secondary-default"
    assert_selector "button.border-border-interactive"
  end

  def test_renders_tertiary_hierarchy
    render_inline(Shipwright::ButtonComponent.new(hierarchy: :tertiary)) { "Tertiary" }

    assert_selector "button.bg-transparent"
    assert_selector "button.text-text-primary"
  end

  def test_renders_destructive_hierarchy
    render_inline(Shipwright::ButtonComponent.new(hierarchy: :destructive)) { "Delete" }

    assert_selector "button.bg-utility-negative-default"
    assert_selector "button.text-text-inverse"
  end

  def test_renders_small_size
    render_inline(Shipwright::ButtonComponent.new(size: :sm)) { "Small" }

    assert_selector "button.h-8"
    assert_selector "button.text-sm"
  end

  def test_renders_medium_size
    render_inline(Shipwright::ButtonComponent.new(size: :md)) { "Medium" }

    assert_selector "button.h-11"
    assert_selector "button.text-base"
  end

  def test_renders_large_size
    render_inline(Shipwright::ButtonComponent.new(size: :lg)) { "Large" }

    assert_selector "button.h-13"
    assert_selector "button.text-base"
  end

  def test_renders_rounded_shape_by_default
    render_inline(Shipwright::ButtonComponent.new) { "Rounded" }

    assert_selector "button.rounded-md"
  end

  def test_renders_pill_shape
    render_inline(Shipwright::ButtonComponent.new(shape: :pill)) { "Pill" }

    assert_selector "button.rounded-full"
    assert_no_selector "button.rounded-md"
  end

  def test_icon_only_uses_square_dimensions
    render_inline(Shipwright::ButtonComponent.new(size: :md, icon_only: true)) { "*" }

    assert_selector "button.h-11"
    assert_selector "button.w-11"
    assert_selector "button.p-0"
  end

  def test_icon_only_sizes_are_square
    render_inline(Shipwright::ButtonComponent.new(size: :sm, icon_only: true)) { "*" }
    assert_selector "button.h-8.w-8"

    render_inline(Shipwright::ButtonComponent.new(size: :lg, icon_only: true)) { "*" }
    assert_selector "button.h-13.w-13"
  end

  def test_disabled_applies_disabled_styles_and_attribute
    render_inline(Shipwright::ButtonComponent.new(disabled: true)) { "Off" }

    assert_selector "button[disabled]"
    assert_selector "button.bg-interactive-disable"
    assert_selector "button.text-text-disabled"
    assert_selector "button.cursor-not-allowed"
    # Primary color should not be applied when disabled
    assert_no_selector "button.bg-interactive-primary-default"
  end

  def test_consumer_class_overrides_defaults
    render_inline(Shipwright::ButtonComponent.new(class: "bg-utility-negative-default")) { "Custom" }

    assert_selector "button.bg-utility-negative-default"
    # Default primary bg should be replaced via tailwind_merge
    assert_no_selector "button.bg-interactive-primary-default"
  end

  def test_passes_html_attributes
    render_inline(Shipwright::ButtonComponent.new(id: "my-btn", data: { action: "click" })) { "Attrs" }

    assert_selector "button#my-btn[data-action='click']"
  end

  def test_raises_on_invalid_hierarchy
    assert_raises(ArgumentError) do
      render_inline(Shipwright::ButtonComponent.new(hierarchy: :danger)) { "Bad" }
    end
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      render_inline(Shipwright::ButtonComponent.new(size: :xl)) { "Bad" }
    end
  end

  def test_raises_on_invalid_shape
    assert_raises(ArgumentError) do
      render_inline(Shipwright::ButtonComponent.new(shape: :square)) { "Bad" }
    end
  end
end

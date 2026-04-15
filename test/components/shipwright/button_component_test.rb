require "test_helper"

class Shipwright::ButtonComponentTest < ViewComponent::TestCase
  def test_renders_primary_button_by_default
    render_inline(Shipwright::ButtonComponent.new) { "Click me" }

    assert_selector "button", text: "Click me"
    assert_selector "button.bg-primary"
    assert_selector "button.text-white"
  end

  def test_renders_secondary_variant
    render_inline(Shipwright::ButtonComponent.new(variant: :secondary)) { "Secondary" }

    assert_selector "button.bg-secondary"
  end

  def test_renders_outline_variant
    render_inline(Shipwright::ButtonComponent.new(variant: :outline)) { "Outline" }

    assert_selector "button.border"
    assert_selector "button.border-primary"
    assert_no_selector "button.bg-primary"
  end

  def test_renders_small_size
    render_inline(Shipwright::ButtonComponent.new(size: :sm)) { "Small" }

    assert_selector "button.text-sm"
    assert_selector "button.px-3"
  end

  def test_renders_large_size
    render_inline(Shipwright::ButtonComponent.new(size: :lg)) { "Large" }

    assert_selector "button.text-lg"
    assert_selector "button.px-6"
  end

  def test_consumer_class_overrides_defaults
    render_inline(Shipwright::ButtonComponent.new(class: "bg-red-500")) { "Custom" }

    assert_selector "button.bg-red-500"
    # bg-primary should be replaced by bg-red-500 via tailwind_merge
    assert_no_selector "button.bg-primary"
  end

  def test_passes_html_attributes
    render_inline(Shipwright::ButtonComponent.new(id: "my-btn", data: { action: "click" })) { "Attrs" }

    assert_selector "button#my-btn[data-action='click']"
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) do
      render_inline(Shipwright::ButtonComponent.new(variant: :danger)) { "Bad" }
    end
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      render_inline(Shipwright::ButtonComponent.new(size: :xl)) { "Bad" }
    end
  end
end

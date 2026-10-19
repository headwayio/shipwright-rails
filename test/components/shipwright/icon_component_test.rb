require "test_helper"

class Shipwright::IconComponentTest < ViewComponent::TestCase
  def test_renders_known_icon_by_name
    render_inline(Shipwright::IconComponent.new(name: :info))

    assert_selector "svg"
    assert_selector "svg circle[cx='12'][cy='12'][r='10']"
  end

  def test_uses_current_color_for_stroke
    render_inline(Shipwright::IconComponent.new(name: :check))

    assert_selector "svg[stroke='currentColor']"
  end

  def test_default_size_is_medium_24
    render_inline(Shipwright::IconComponent.new(name: :info))

    assert_selector "svg.w-6.h-6"
  end

  def test_small_size_16
    render_inline(Shipwright::IconComponent.new(name: :info, size: :sm))

    assert_selector "svg.w-4.h-4"
  end

  def test_large_size_32
    render_inline(Shipwright::IconComponent.new(name: :info, size: :lg))

    assert_selector "svg.w-8.h-8"
  end

  def test_accepts_string_or_symbol_name
    render_inline(Shipwright::IconComponent.new(name: "info"))
    assert_selector "svg"
  end

  def test_consumer_class_merges
    render_inline(Shipwright::IconComponent.new(name: :info, class: "text-utility-negative-default"))

    assert_selector "svg.text-utility-negative-default"
  end

  def test_passes_html_attributes
    render_inline(Shipwright::IconComponent.new(name: :info, id: "info-icon", data: { action: "tooltip" }))

    assert_selector "svg#info-icon[data-action='tooltip']"
  end

  def test_aria_hidden_by_default
    render_inline(Shipwright::IconComponent.new(name: :info))

    assert_selector "svg[aria-hidden='true']"
  end

  def test_aria_label_makes_icon_visible_to_assistive_tech
    render_inline(Shipwright::IconComponent.new(name: :info, "aria-label": "More information"))

    assert_selector "svg[aria-label='More information']"
    # When aria-label is explicitly set, the icon should not be aria-hidden
    assert_no_selector "svg[aria-hidden='true']"
  end

  def test_raises_on_unknown_icon
    assert_raises(ArgumentError) do
      render_inline(Shipwright::IconComponent.new(name: :nonexistent))
    end
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      render_inline(Shipwright::IconComponent.new(name: :info, size: :xl))
    end
  end

  def test_exposes_available_icon_names
    assert_kind_of Array, Shipwright::IconComponent.icon_names
    assert_includes Shipwright::IconComponent.icon_names, :info
    assert_includes Shipwright::IconComponent.icon_names, :check
    assert_includes Shipwright::IconComponent.icon_names, :"chevron-down"
  end
end

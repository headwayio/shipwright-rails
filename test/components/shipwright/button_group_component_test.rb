require "test_helper"
require "cgi"

class Shipwright::ButtonGroupComponentTest < ViewComponent::TestCase
  def unescaped_html
    CGI.unescapeHTML(rendered_content)
  end

  def test_renders_buttons_inside_group
    render_inline(Shipwright::ButtonGroupComponent.new) do |group|
      group.with_button { "Edit" }
      group.with_button { "Copy" }
      group.with_button { "Delete" }
    end

    assert_selector "div > button", count: 3
    assert_selector "button", text: "Edit"
    assert_selector "button", text: "Copy"
    assert_selector "button", text: "Delete"
  end

  def test_defaults_to_compact_horizontal
    render_inline(Shipwright::ButtonGroupComponent.new) do |group|
      group.with_button { "A" }
      group.with_button { "B" }
    end

    assert_selector "div.inline-flex.flex-row.gap-0"
  end

  def test_regular_density_applies_gap
    render_inline(Shipwright::ButtonGroupComponent.new(density: :regular)) do |group|
      group.with_button { "A" }
      group.with_button { "B" }
    end

    assert_selector "div.gap-2xs"
    assert_no_selector "div.gap-0"
  end

  def test_vertical_orientation_uses_flex_col
    render_inline(Shipwright::ButtonGroupComponent.new(orientation: :vertical)) do |group|
      group.with_button { "A" }
      group.with_button { "B" }
    end

    assert_selector "div.flex-col"
    assert_no_selector "div.flex-row"
  end

  def test_compact_horizontal_applies_radius_child_selectors
    render_inline(Shipwright::ButtonGroupComponent.new(density: :compact, orientation: :horizontal)) do |group|
      group.with_button { "A" }
      group.with_button { "B" }
    end

    html = unescaped_html
    assert_includes html, "[&>button:first-child]:rounded-r-none"
    assert_includes html, "[&>button:last-child]:rounded-l-none"
    assert_includes html, "[&>button:not(:first-child)]:-ml-px"
  end

  def test_compact_vertical_applies_vertical_radius_selectors
    render_inline(Shipwright::ButtonGroupComponent.new(density: :compact, orientation: :vertical)) do |group|
      group.with_button { "A" }
      group.with_button { "B" }
    end

    html = unescaped_html
    assert_includes html, "[&>button:first-child]:rounded-b-none"
    assert_includes html, "[&>button:last-child]:rounded-t-none"
    assert_includes html, "[&>button:not(:first-child)]:-mt-px"
  end

  def test_regular_density_does_not_apply_radius_overrides
    render_inline(Shipwright::ButtonGroupComponent.new(density: :regular)) do |group|
      group.with_button { "A" }
      group.with_button { "B" }
    end

    html = unescaped_html
    refute_includes html, "rounded-r-none"
    refute_includes html, "rounded-l-none"
    refute_includes html, "-ml-px"
  end

  def test_passes_hierarchy_to_button_slot
    render_inline(Shipwright::ButtonGroupComponent.new) do |group|
      group.with_button(hierarchy: :tertiary) { "T" }
    end

    assert_selector "button.bg-transparent"
  end

  def test_supports_icon_only_buttons_in_group
    render_inline(Shipwright::ButtonGroupComponent.new) do |group|
      group.with_button(icon_only: true) { "*" }
      group.with_button(icon_only: true) { "+" }
    end

    assert_selector "button.w-11", count: 2
  end

  def test_consumer_class_merges_via_tailwind_merge
    render_inline(Shipwright::ButtonGroupComponent.new(class: "shadow-lg")) do |group|
      group.with_button { "A" }
    end

    assert_selector "div.shadow-lg"
  end

  def test_raises_on_invalid_density
    assert_raises(ArgumentError) do
      render_inline(Shipwright::ButtonGroupComponent.new(density: :sparse)) do |group|
        group.with_button { "A" }
      end
    end
  end

  def test_raises_on_invalid_orientation
    assert_raises(ArgumentError) do
      render_inline(Shipwright::ButtonGroupComponent.new(orientation: :diagonal)) do |group|
        group.with_button { "A" }
      end
    end
  end
end

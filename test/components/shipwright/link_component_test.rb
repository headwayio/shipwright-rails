require "test_helper"

class Shipwright::LinkComponentTest < ViewComponent::TestCase
  def test_renders_anchor_with_content_and_href
    render_inline(Shipwright::LinkComponent.new(href: "/about")) { "About" }

    assert_selector "a[href='/about']", text: "About"
  end

  def test_default_has_primary_color_and_underline
    render_inline(Shipwright::LinkComponent.new(href: "#")) { "Link" }

    assert_selector "a.text-interactive-primary-default"
    assert_selector "a.underline"
  end

  def test_no_decoration_removes_underline
    render_inline(Shipwright::LinkComponent.new(href: "#", decoration: :none)) { "Link" }

    assert_selector "a.no-underline"
    assert_no_selector "a.underline"
  end

  def test_applies_hover_and_active_color_classes
    render_inline(Shipwright::LinkComponent.new(href: "#")) { "Link" }

    assert_selector "a.hover\\:text-interactive-primary-hover"
    assert_selector "a.active\\:text-interactive-primary-pressed"
  end

  def test_disabled_link_uses_disabled_color_and_aria
    render_inline(Shipwright::LinkComponent.new(href: "#", disabled: true)) { "Off" }

    assert_selector "a[aria-disabled='true']"
    assert_selector "a.text-interactive-disable"
    assert_selector "a.cursor-not-allowed"
    # Disabled links shouldn't carry an href to prevent navigation
    assert_no_selector "a[href='#']"
  end

  def test_consumer_class_overrides_defaults
    render_inline(Shipwright::LinkComponent.new(href: "#", class: "text-utility-negative-default")) { "Danger" }

    assert_selector "a.text-utility-negative-default"
    assert_no_selector "a.text-interactive-primary-default"
  end

  def test_passes_html_attributes
    render_inline(Shipwright::LinkComponent.new(href: "#", target: "_blank", id: "ext", data: { turbo: "false" })) { "External" }

    assert_selector "a#ext[target='_blank'][data-turbo='false']"
  end

  def test_renders_without_href_when_not_provided
    render_inline(Shipwright::LinkComponent.new) { "Trigger" }

    assert_selector "a", text: "Trigger"
    assert_no_selector "a[href]"
  end

  def test_includes_focus_ring_classes
    render_inline(Shipwright::LinkComponent.new(href: "#")) { "Link" }

    html = rendered_content
    assert_includes html, "focus-visible:"
    assert_includes html, "ring"
  end

  def test_raises_on_invalid_decoration
    assert_raises(ArgumentError) do
      render_inline(Shipwright::LinkComponent.new(href: "#", decoration: :strikethrough)) { "Bad" }
    end
  end

  def test_typography_classes_applied
    render_inline(Shipwright::LinkComponent.new(href: "#")) { "Link" }

    assert_selector "a.text-sm"
    assert_selector "a.font-sans"
  end
end

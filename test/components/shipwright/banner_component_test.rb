require "test_helper"

class Shipwright::BannerComponentTest < ViewComponent::TestCase
  def test_renders_body_content
    render_inline(Shipwright::BannerComponent.new) { "Body message here." }

    assert_text "Body message here."
  end

  def test_has_secondary_background
    render_inline(Shipwright::BannerComponent.new) { "Body." }

    assert_selector "div.bg-background-secondary"
  end

  def test_renders_header_when_provided
    render_inline(Shipwright::BannerComponent.new(header: "Alert")) { "Body." }

    assert_text "Alert"
  end

  def test_omits_header_block_when_no_header_or_icon
    render_inline(Shipwright::BannerComponent.new) { "Body." }

    assert_no_selector "[data-banner-header]"
  end

  def test_renders_icon_slot
    render_inline(Shipwright::BannerComponent.new(header: "Alert")) do |banner|
      banner.with_icon(name: :info)
      "Body text."
    end

    assert_selector "[data-banner-header] svg"
  end

  def test_renders_link_slot
    render_inline(Shipwright::BannerComponent.new) do |banner|
      banner.with_link(href: "/more") { "Details" }
      "Body text."
    end

    assert_selector "a[href='/more']", text: "Details"
  end

  def test_renders_icon_and_link_together
    render_inline(Shipwright::BannerComponent.new(header: "Alert")) do |banner|
      banner.with_icon(name: :info)
      banner.with_link(href: "#") { "Link" }
      "Body text."
    end

    assert_selector "[data-banner-header] svg"
    assert_text "Alert"
    assert_text "Body text."
    assert_selector "a", text: "Link"
  end

  def test_consumer_class_overrides_default_bg
    render_inline(Shipwright::BannerComponent.new(class: "bg-utility-warning-default")) { "Warn." }

    assert_selector "div.bg-utility-warning-default"
    assert_no_selector "div.bg-background-secondary"
  end

  def test_passes_html_attributes
    render_inline(Shipwright::BannerComponent.new(id: "my-banner", role: "status")) { "Info." }

    assert_selector "div#my-banner[role='status']"
  end

  def test_body_text_uses_typography_classes
    render_inline(Shipwright::BannerComponent.new) { "Body." }

    assert_selector "div.font-sans"
    assert_selector "p.text-sm", text: "Body."
  end

  def test_shows_only_icon_without_header
    render_inline(Shipwright::BannerComponent.new) do |banner|
      banner.with_icon(name: :"alert-circle")
      "Body only."
    end

    assert_selector "svg"
    assert_text "Body only."
  end

  def test_renders_avatar_slot_as_leading_visual
    render_inline(Shipwright::BannerComponent.new(header: "From John")) do |banner|
      banner.with_avatar(initials: "JD")
      "Body."
    end

    assert_selector "[data-banner-header] span", text: "JD"
    assert_text "From John"
  end

  def test_renders_logo_slot_as_leading_visual
    render_inline(Shipwright::BannerComponent.new(header: "Acme update")) do |banner|
      banner.with_logo(alt: "Acme")
      "Body."
    end

    assert_selector "[data-banner-header] [role='img'][aria-label='Acme'], [data-banner-header] svg"
    assert_text "Acme update"
  end
end

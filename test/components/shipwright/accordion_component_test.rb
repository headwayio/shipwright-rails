require "test_helper"

class Shipwright::AccordionComponentTest < ViewComponent::TestCase
  def test_renders_title_and_body
    render_inline(Shipwright::AccordionComponent.new(title: "What is it?")) { "A body." }

    assert_selector "details"
    assert_selector "summary", text: "What is it?"
    assert_text "A body."
  end

  def test_closed_by_default
    render_inline(Shipwright::AccordionComponent.new(title: "T")) { "B" }

    assert_no_selector "details[open]"
  end

  def test_open_param_renders_as_open
    render_inline(Shipwright::AccordionComponent.new(title: "T", open: true)) { "B" }

    assert_selector "details[open]"
  end

  def test_chevron_icon_rendered
    render_inline(Shipwright::AccordionComponent.new(title: "T")) { "B" }

    # Uses IconComponent, so an <svg> will appear inside <summary>
    assert_selector "summary svg"
  end

  def test_chevron_rotates_when_open
    render_inline(Shipwright::AccordionComponent.new(title: "T", open: true)) { "B" }

    html = rendered_content
    assert_includes html, "group-open:rotate-180"
  end

  def test_summary_has_border_and_padding_classes
    render_inline(Shipwright::AccordionComponent.new(title: "T")) { "B" }

    html = rendered_content
    assert_includes html, "border-border-primary"
    assert_includes html, "px-4"
    assert_includes html, "py-3"
  end

  def test_hover_and_focus_classes_present
    render_inline(Shipwright::AccordionComponent.new(title: "T")) { "B" }

    html = rendered_content
    assert_includes html, "hover:bg-background-secondary"
    assert_includes html, "focus-visible:"
  end

  def test_summary_hides_default_marker
    render_inline(Shipwright::AccordionComponent.new(title: "T")) { "B" }

    html = rendered_content
    assert_includes html, "list-none"
    assert_includes html, "::-webkit-details-marker"
  end

  def test_consumer_class_merges
    render_inline(Shipwright::AccordionComponent.new(title: "T", class: "shadow-lg")) { "B" }

    assert_selector "details.shadow-lg"
  end

  def test_passes_html_attributes_to_details
    render_inline(Shipwright::AccordionComponent.new(title: "T", id: "faq-1", data: { section: "faq" })) { "B" }

    assert_selector "details#faq-1[data-section='faq']"
  end

  def test_typography_applied_to_title
    render_inline(Shipwright::AccordionComponent.new(title: "Title")) { "B" }

    html = rendered_content
    # Title should have Manrope + base font size
    assert_includes html, "text-base"
    assert_includes html, "font-sans"
  end

  def test_body_rendered_below_summary
    render_inline(Shipwright::AccordionComponent.new(title: "T", open: true)) { "Body contents here." }

    # Body should be a sibling of summary inside details
    assert_selector "details > summary"
    assert_selector "details > div", text: "Body contents here."
  end
end

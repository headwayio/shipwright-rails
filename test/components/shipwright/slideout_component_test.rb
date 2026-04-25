require "test_helper"

class Shipwright::SlideoutComponentTest < ViewComponent::TestCase
  def test_renders_dialog_with_id
    render_inline(Shipwright::SlideoutComponent.new(id: "my-sheet"))

    assert_selector "dialog#my-sheet"
  end

  def test_default_position_is_right
    render_inline(Shipwright::SlideoutComponent.new(id: "x"))

    assert_includes rendered_content, "shipwright-slideout-position=\"right\""
    assert_includes rendered_content, "right-0"
    # MUST clear UA <dialog>:modal inset (left:0) or panel anchors wrong
    assert_includes rendered_content, "left-auto"
  end

  def test_left_position_anchors_left
    render_inline(Shipwright::SlideoutComponent.new(id: "x", position: :left))

    assert_includes rendered_content, "shipwright-slideout-position=\"left\""
    assert_includes rendered_content, "left-0"
    assert_includes rendered_content, "right-auto"
  end

  def test_bottom_position_anchors_bottom_full_width
    render_inline(Shipwright::SlideoutComponent.new(id: "x", position: :bottom))

    assert_includes rendered_content, "shipwright-slideout-position=\"bottom\""
    assert_includes rendered_content, "w-full"
    assert_includes rendered_content, "rounded-t-lg"
    assert_includes rendered_content, "top-auto"
  end

  def test_raises_on_invalid_position
    assert_raises(ArgumentError) do
      Shipwright::SlideoutComponent.new(id: "x", position: :top)
    end
  end

  def test_side_positions_default_to_fixed_width
    render_inline(Shipwright::SlideoutComponent.new(id: "x", position: :right))

    assert_selector "dialog[style*='width: 428px']", visible: :all
  end

  def test_custom_width_applied
    render_inline(Shipwright::SlideoutComponent.new(id: "x", width: "320px"))

    assert_selector "dialog[style*='width: 320px']", visible: :all
  end

  def test_bottom_position_has_no_fixed_width
    render_inline(Shipwright::SlideoutComponent.new(id: "x", position: :bottom))

    refute_includes rendered_content, "width: 428px"
  end

  def test_title_and_subtitle_rendered_in_header
    render_inline(Shipwright::SlideoutComponent.new(id: "x", title: "Edit profile", subtitle: "Update your info"))

    assert_selector "h2#x-title", text: "Edit profile"
    assert_text "Update your info"
  end

  def test_close_button_rendered_by_default
    render_inline(Shipwright::SlideoutComponent.new(id: "x", title: "t"))

    assert_selector "button[data-shipwright-slideout-close='x'][aria-label='Close']"
  end

  def test_close_button_hidden_when_disabled
    render_inline(Shipwright::SlideoutComponent.new(id: "x", title: "t", close_button: false))

    assert_no_selector "[data-shipwright-slideout-close]"
  end

  def test_tabs_rendered_when_given
    render_inline(Shipwright::SlideoutComponent.new(id: "x")) do |s|
      s.with_tab(label: "Details", icon: :user, active: true)
      s.with_tab(label: "Security", icon: :lock)
    end

    assert_selector "[role='tablist']"
    assert_selector "[role='tab']", count: 2
    assert_selector "[role='tab'][aria-selected='true']", text: "Details"
  end

  def test_tabs_with_href_render_as_links
    render_inline(Shipwright::SlideoutComponent.new(id: "x")) do |s|
      s.with_tab(label: "Details", href: "/details", active: true)
    end

    assert_selector "a[href='/details'][role='tab']"
  end

  def test_actions_rendered_in_footer
    render_inline(Shipwright::SlideoutComponent.new(id: "x", title: "t")) do |s|
      s.with_action { "Cancel".html_safe }
      s.with_action { "Save".html_safe }
    end

    assert_text "Cancel"
    assert_text "Save"
  end

  def test_body_content_rendered_between_header_and_footer
    render_inline(Shipwright::SlideoutComponent.new(id: "x", title: "t")) { "<p>body content</p>".html_safe }

    assert_selector "p", text: "body content"
  end

  def test_aria_labelledby_points_to_title_when_present
    render_inline(Shipwright::SlideoutComponent.new(id: "x", title: "My sheet"))

    assert_selector "dialog[aria-labelledby='x-title']"
  end

  def test_initially_open_marks_state_open
    render_inline(Shipwright::SlideoutComponent.new(id: "x", initially_open: true))

    assert_includes rendered_content, 'data-shipwright-slideout-state="open"'
    assert_includes rendered_content, 'data-initially-open="true"'
  end

  def test_default_state_is_closed
    render_inline(Shipwright::SlideoutComponent.new(id: "x"))

    assert_includes rendered_content, 'data-shipwright-slideout-state="closed"'
  end

  def test_custom_header_slot_overrides_title_subtitle
    render_inline(Shipwright::SlideoutComponent.new(id: "x", title: "IGNORED")) do |s|
      s.with_header { '<div data-custom-header>Custom</div>'.html_safe }
    end

    assert_selector "[data-custom-header]", text: "Custom"
    refute_includes rendered_content, "IGNORED"
  end

  def test_consumer_class_merges_on_dialog
    render_inline(Shipwright::SlideoutComponent.new(id: "x", class: "my-8"))

    assert_selector "dialog.my-8"
  end

  def test_wires_init_script_once_per_render
    render_inline(Shipwright::SlideoutComponent.new(id: "x"))

    assert_includes rendered_content, "__shipwrightSlideoutWired"
  end

  def test_no_header_block_rendered_when_no_title_close_or_header_slot
    render_inline(Shipwright::SlideoutComponent.new(id: "x", close_button: false))

    # No header container should appear
    refute_includes rendered_content, "border-b border-border-primary"
  end
end

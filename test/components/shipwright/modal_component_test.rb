require "test_helper"

class Shipwright::ModalComponentTest < ViewComponent::TestCase
  def test_renders_dialog_with_id
    render_inline(Shipwright::ModalComponent.new(id: "confirm"))

    assert_selector "dialog#confirm.shipwright-modal"
  end

  def test_default_size_is_md
    render_inline(Shipwright::ModalComponent.new(id: "x"))

    assert_includes rendered_content, 'shipwright-modal-size="md"'
    assert_includes rendered_content, "max-w-[448px]"
  end

  def test_each_size_applies_max_width_class
    # Arbitrary px values rather than max-w-sm/md/lg, because Shipwright's
    # @theme defines --spacing-sm/md/lg tokens that hijack those utilities.
    {sm: "max-w-[384px]", md: "max-w-[448px]", lg: "max-w-[672px]", xl: "max-w-[896px]"}.each do |size, css|
      render_inline(Shipwright::ModalComponent.new(id: "x", size: size))
      assert_includes rendered_content, css, "size :#{size} should produce #{css}"
    end
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) { Shipwright::ModalComponent.new(id: "x", size: :huge) }
  end

  def test_title_and_subtitle_render
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "Delete?", subtitle: "Cannot be undone"))

    assert_selector "h2#x-title", text: "Delete?"
    assert_text "Cannot be undone"
  end

  def test_close_button_default_present
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "t"))

    assert_selector "button[data-shipwright-modal-close='x'][aria-label='Close']"
  end

  def test_close_button_can_be_disabled
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "t", close_button: false))

    assert_no_selector "[data-shipwright-modal-close]"
  end

  def test_actions_rendered_in_footer
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "t")) do |m|
      m.with_action { "Cancel".html_safe }
      m.with_action { "Confirm".html_safe }
    end

    assert_text "Cancel"
    assert_text "Confirm"
  end

  def test_body_content_rendered
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "t")) { "<p>body</p>".html_safe }

    assert_selector "p", text: "body"
  end

  def test_aria_labelledby_points_to_title
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "Hello"))

    assert_selector "dialog[aria-labelledby='x-title']"
  end

  def test_initially_open_sets_state_attr
    render_inline(Shipwright::ModalComponent.new(id: "x", initially_open: true))

    assert_includes rendered_content, 'data-shipwright-modal-state="open"'
    assert_includes rendered_content, 'data-initially-open="true"'
  end

  def test_default_state_is_closed
    render_inline(Shipwright::ModalComponent.new(id: "x"))

    assert_includes rendered_content, 'data-shipwright-modal-state="closed"'
  end

  def test_custom_header_overrides_title
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "IGNORED")) do |m|
      m.with_header { '<div data-custom>Custom</div>'.html_safe }
    end

    assert_selector "[data-custom]"
    refute_includes rendered_content, "IGNORED"
  end

  def test_header_class_override_merges
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "t", header_class: "bg-utility-warning-default"))

    assert_includes rendered_content, "bg-utility-warning-default"
  end

  def test_body_class_override_merges
    render_inline(Shipwright::ModalComponent.new(id: "x", body_class: "px-md"))

    assert_includes rendered_content, "px-md"
  end

  def test_footer_class_override_merges
    render_inline(Shipwright::ModalComponent.new(id: "x", footer_class: "bg-background-tertiary")) do |m|
      m.with_action { "x".html_safe }
    end

    assert_includes rendered_content, "bg-background-tertiary"
  end

  def test_consumer_class_merges_on_dialog
    render_inline(Shipwright::ModalComponent.new(id: "x", class: "my-8"))

    assert_selector "dialog.my-8"
  end

  def test_init_script_wired
    render_inline(Shipwright::ModalComponent.new(id: "x"))

    assert_includes rendered_content, "__shipwrightModalWired"
  end

  def test_header_has_secondary_background_by_default
    render_inline(Shipwright::ModalComponent.new(id: "x", title: "t"))

    assert_includes rendered_content, "bg-background-secondary"
  end
end

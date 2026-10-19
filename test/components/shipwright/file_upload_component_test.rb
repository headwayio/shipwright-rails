require "test_helper"

class Shipwright::FileUploadComponentTest < ViewComponent::TestCase
  def test_renders_label_and_caption
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", label: "Upload", caption: "PDF only"))

    assert_text "Upload"
    assert_text "PDF only"
  end

  def test_renders_hidden_file_input_with_name
    render_inline(Shipwright::FileUploadComponent.new(name: "document"))

    assert_selector "input[type='file'][name='document']", visible: :all
  end

  def test_multiple_applies_attribute
    render_inline(Shipwright::FileUploadComponent.new(name: "docs[]", multiple: true))

    assert_selector "input[type='file'][multiple]", visible: :all
  end

  def test_accept_applies_attribute
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", accept: ".pdf,.png"))

    assert_selector "input[type='file'][accept='.pdf,.png']", visible: :all
  end

  def test_disabled_applies_attribute
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", disabled: true))

    assert_selector "input[type='file'][disabled]", visible: :all
  end

  def test_inline_variant_renders_choose_button_and_placeholder
    render_inline(Shipwright::FileUploadComponent.new(name: "doc"))

    assert_selector "[data-file-upload-trigger]", text: "Choose file"
    assert_selector "[data-file-upload-filename]", text: "No file selected"
  end

  def test_button_position_left_renders_button_first
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", button_position: :left))

    # First child of the field row should be the trigger button
    html = rendered_content
    first_trigger = html.index("data-file-upload-trigger")
    first_filename = html.index("data-file-upload-filename")
    assert first_trigger < first_filename, "Trigger should appear before filename when button_position: :left"
  end

  def test_dropzone_variant_renders_drop_target
    render_inline(Shipwright::FileUploadComponent.new(name: "docs[]", variant: :dropzone, multiple: true))

    assert_selector "[data-file-upload-dropzone]"
    assert_text "Click to upload or drag and drop"
    assert_selector "[data-file-upload-trigger]", text: /Browse files/
  end

  def test_error_state_shows_message_and_applies_destructive_color
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", error: "Something went wrong"))

    assert_text "Something went wrong"
    assert_includes rendered_content, "utility-negative-default"
  end

  def test_caption_shown_when_no_error
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", caption: "Helper text"))

    assert_selector "[data-file-upload-message]", text: "Helper text"
  end

  def test_max_size_surfaces_as_data_attribute
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", max_size: 10 * 1024 * 1024))

    assert_includes rendered_content, "data-file-upload-max-size"
    assert_includes rendered_content, (10 * 1024 * 1024).to_s
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) { Shipwright::FileUploadComponent.new(name: "doc", variant: :bogus) }
  end

  def test_raises_on_invalid_button_position
    assert_raises(ArgumentError) { Shipwright::FileUploadComponent.new(name: "doc", button_position: :top) }
  end

  def test_raises_on_invalid_button_variant
    assert_raises(ArgumentError) { Shipwright::FileUploadComponent.new(name: "doc", button_variant: :ghost) }
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::FileUploadComponent.new(name: "doc", class: "my-8"))

    assert_selector "div.my-8[data-shipwright-file-upload]"
  end

  def test_staged_list_template_present
    render_inline(Shipwright::FileUploadComponent.new(name: "doc"))

    assert_selector "template[data-file-upload-item-template]", visible: :all
  end

  def test_staged_list_template_is_inside_wrapper
    # The JS does wrapper.querySelector("[data-file-upload-item-template]"),
    # which only searches descendants. The template must live inside the
    # wrapper div, not as a sibling, or stage/remove/render all break.
    render_inline(Shipwright::FileUploadComponent.new(name: "doc"))

    assert_selector "[data-shipwright-file-upload] template[data-file-upload-item-template]", visible: :all
  end

  def test_wraps_init_script_once
    render_inline(Shipwright::FileUploadComponent.new(name: "doc"))

    assert_includes rendered_content, "__shipwrightFileUploadWired"
  end
end

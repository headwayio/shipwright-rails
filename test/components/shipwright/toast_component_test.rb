require "test_helper"

class Shipwright::ToastComponentTest < ViewComponent::TestCase
  def test_renders_title_and_body
    render_inline(Shipwright::ToastComponent.new(title: "Saved", body: "Your changes are live."))

    assert_text "Saved"
    assert_text "Your changes are live."
  end

  def test_renders_without_body
    render_inline(Shipwright::ToastComponent.new(title: "Saved"))

    assert_text "Saved"
  end

  def test_renders_dismiss_button_by_default
    render_inline(Shipwright::ToastComponent.new(title: "Saved"))

    assert_selector "[data-shipwright-toast-dismiss]"
  end

  def test_hides_dismiss_button_when_not_dismissible
    render_inline(Shipwright::ToastComponent.new(title: "Saved", dismissible: false))

    assert_no_selector "[data-shipwright-toast-dismiss]"
  end

  def test_variant_applies_color_to_icon_circle
    render_inline(Shipwright::ToastComponent.new(title: "Saved", variant: :success))
    assert_includes rendered_content, "utility-positive-default"

    render_inline(Shipwright::ToastComponent.new(title: "Failed", variant: :error))
    assert_includes rendered_content, "utility-negative-default"

    render_inline(Shipwright::ToastComponent.new(title: "Heads up", variant: :warning))
    assert_includes rendered_content, "utility-warning-default"
  end

  def test_duration_stored_as_data_attribute
    render_inline(Shipwright::ToastComponent.new(title: "Saved", duration: 3000))

    assert_includes rendered_content, "data-shipwright-toast-duration=\"3000\""
  end

  def test_duration_zero_means_sticky
    render_inline(Shipwright::ToastComponent.new(title: "Sticky", duration: 0))

    assert_includes rendered_content, "data-shipwright-toast-duration=\"0\""
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) { Shipwright::ToastComponent.new(title: "x", variant: :weird) }
  end

  def test_custom_id_respected
    render_inline(Shipwright::ToastComponent.new(title: "x", id: "my-toast"))

    assert_selector "#my-toast"
  end

  def test_aria_role_and_live_region
    render_inline(Shipwright::ToastComponent.new(title: "x"))

    assert_selector "[role='status'][aria-live='polite']"
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::ToastComponent.new(title: "x", class: "my-8"))

    assert_selector ".my-8[data-shipwright-toast]"
  end

  def test_icon_override_uses_provided_icon
    render_inline(Shipwright::ToastComponent.new(title: "x", variant: :success, icon: :mail))

    # Feather's `mail` icon path — confirm override wins over variant default
    assert_includes rendered_content, "M4 4h16c1.1 0"
  end

  def test_variant_default_icon_used_when_no_override
    render_inline(Shipwright::ToastComponent.new(title: "x", variant: :error))

    # alert-circle is the default for :error
    assert_selector "svg"
    refute_includes rendered_content, "M4 4h16c1.1 0" # not the mail icon
  end

  def test_wires_init_script_once
    render_inline(Shipwright::ToastComponent.new(title: "x"))

    assert_includes rendered_content, "__shipwrightToastWired"
  end
end

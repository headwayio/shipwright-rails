require "test_helper"

# Exercises the helper through a real ActionView context so `render` and
# `safe_join` are available.
class Shipwright::FlashHelperTest < ActionView::TestCase
  include Shipwright::FlashHelper

  def test_notice_renders_success_toast
    html = shipwright_flash_toasts({ "notice" => "Profile updated" })

    assert_includes html, "Profile updated"
    assert_includes html, "utility-positive-default"
  end

  def test_alert_renders_error_toast
    html = shipwright_flash_toasts({ "alert" => "Not found" })

    assert_includes html, "Not found"
    assert_includes html, "utility-negative-default"
  end

  def test_warning_renders_warning_toast
    html = shipwright_flash_toasts({ "warning" => "Quota nearly full" })

    assert_includes html, "utility-warning-default"
  end

  def test_unknown_key_is_skipped
    html = shipwright_flash_toasts({ "form_id" => "user" })

    refute_includes html, "shipwright-toast"
  end

  def test_blank_values_skipped
    html = shipwright_flash_toasts({ "notice" => "" })

    refute_includes html, "shipwright-toast"
  end

  def test_custom_mapping
    html = shipwright_flash_toasts({ "my_event" => "Hello" }, mapping: { my_event: :info })

    assert_includes html, "Hello"
    assert_includes html, "interactive-primary-default"
  end

  def test_toast_opts_forwarded
    html = shipwright_flash_toasts({ "notice" => "Saved" }, duration: 1000)

    assert_includes html, "data-shipwright-toast-duration=\"1000\""
  end

  def test_multiple_flash_entries
    html = shipwright_flash_toasts({ "notice" => "Saved", "alert" => "One issue" })

    assert_includes html, "Saved"
    assert_includes html, "One issue"
  end
end

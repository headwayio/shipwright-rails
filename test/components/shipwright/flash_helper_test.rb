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

  # A flash is one string, and the toast's `title` slot truncates to a single
  # line. Routing the message there silently ate the tail of any message long
  # enough to matter — which is exactly the messages that carry a reason.
  LONG = "We could not process your payment because the card issuer declined " \
         "the transaction. Try another card or contact your bank."

  def test_message_lands_in_the_wrapping_slot_not_the_truncating_one
    html = shipwright_flash_toasts({ "alert" => LONG })

    assert_match %r{<p class="[^"]*break-words[^"]*">#{Regexp.escape(LONG)}</p>}, html
    refute_match %r{<p class="[^"]*truncate[^"]*">#{Regexp.escape(LONG)}</p>}, html
  end

  def test_no_empty_heading_is_rendered_above_the_message
    html = shipwright_flash_toasts({ "notice" => "Saved" })

    refute_match %r{<p class="[^"]*truncate[^"]*"></p>}, html
  end

  def test_a_title_can_still_be_supplied
    html = shipwright_flash_toasts({ "notice" => "Saved" }, title: "Success")

    assert_match %r{<p class="[^"]*truncate[^"]*">Success</p>}, html
    assert_includes html, "Saved"
  end
end

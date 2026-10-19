require "test_helper"

# Components that bootstrap themselves with an inline <script> must carry the
# host application's CSP nonce. Without it an app with a nonce-based
# `script-src` refuses the script and the component silently does nothing —
# the markup renders, the behaviour never wires up.
class Shipwright::InitScriptNonceTest < ViewComponent::TestCase
  # [component, marker, a JS identifier unique to that component's script]
  SCRIPTED_COMPONENTS = [
    [ -> { Shipwright::ToastComponent.new(title: "Saved") },
      "data-shipwright-toast-init", "__shipwrightToastWired" ],
    [ -> { Shipwright::ToastContainerComponent.new },
      "data-shipwright-toast-init", "__shipwrightToastWired" ],
    [ -> { Shipwright::ModalComponent.new(id: "m", title: "T") },
      "data-shipwright-modal-init", "__shipwrightModalWired" ],
    [ -> { Shipwright::SlideoutComponent.new(id: "s") },
      "data-shipwright-slideout-init", "__shipwrightSlideoutWired" ],
    [ -> { Shipwright::DropdownComponent.new(items: [ { label: "A", value: "a" } ]) },
      "data-shipwright-dropdown-init", "__shipwrightDropdownWired" ],
    [ -> { Shipwright::FileUploadComponent.new(name: "doc") },
      "data-shipwright-file-upload-init", "__shipwrightFileUploadWired" ]
  ].freeze

  def test_init_script_carries_the_nonce_when_one_is_configured
    SCRIPTED_COMPONENTS.each do |build, marker, _guard|
      with_nonce("n0nc3") { render_inline(build.call) }

      assert_selector "script[#{marker}][nonce='n0nc3']", visible: false, count: 1
    end
  end

  def test_init_script_omits_the_attribute_when_no_generator_is_configured
    SCRIPTED_COMPONENTS.each do |build, marker, _guard|
      render_inline(build.call)

      assert_selector "script[#{marker}]", visible: false, count: 1
      assert_no_selector "script[#{marker}][nonce]", visible: false
    end
  end

  # The nonce plumbing must not mangle the script body: JavaScript is not
  # HTML-escaped, and the guard variable still reaches the page.
  def test_script_body_survives_intact
    SCRIPTED_COMPONENTS.each do |build, marker, guard|
      with_nonce("n0nc3") { render_inline(build.call) }
      html = page.native.to_html

      assert_includes html, guard, "#{marker} lost its script body"
      refute_includes html, "&lt;", "#{marker} body was HTML-escaped"
    end
  end

  private

  def with_nonce(value)
    vc_test_controller.request.content_security_policy_nonce_generator = ->(_req) { value }
    yield
  ensure
    vc_test_controller.request.content_security_policy_nonce_generator = nil
  end
end

module Shipwright
  # Toast — an ephemeral notification that "pops up" from an edge of the
  # screen, stacks with other toasts, and removes itself after a configurable
  # timeout (or sticks until the user dismisses it).
  #
  # Typically rendered inside a ToastContainerComponent and appended via
  # Turbo Stream, or seeded on first page load via
  # Shipwright::FlashHelper#shipwright_flash_toasts.
  #
  # Each variant ships a sensible default icon (check-circle / alert-circle
  # / alert-triangle / info / bell). Override with any Feather icon name:
  #
  #   render Shipwright::ToastComponent.new(
  #     title: "New message", icon: :mail, variant: :info
  #   )
  #
  # Usage (standalone, e.g. in a partial):
  #   <%= render Shipwright::ToastComponent.new(
  #     title: "Saved",
  #     body: "Your changes are live.",
  #     variant: :success
  #   ) %>
  #
  # Usage (Turbo Stream append):
  #   turbo_stream.append Shipwright::ToastContainerComponent::DOM_ID,
  #     Shipwright::ToastComponent.new(title: "Saved", variant: :success)
  #
  # Variants map to the leading icon circle color and pick a sensible icon.
  class ToastComponent < BaseComponent
    # Each variant pairs an icon-circle background color with a sensible
    # default icon. Pass `icon:` to override the default with any Feather
    # icon name (see Shipwright::Icons::ICONS) — e.g. `icon: :bell`,
    # `icon: :"alert-triangle"`, `icon: :zap`.
    VARIANTS = {
      success: {
        bg: "bg-utility-positive-default",
        icon: :"check-circle"
      },
      error: {
        bg: "bg-utility-negative-default",
        icon: :"alert-circle"
      },
      warning: {
        bg: "bg-utility-warning-default",
        icon: :"alert-triangle"
      },
      info: {
        bg: "bg-interactive-primary-default",
        icon: :info
      },
      neutral: {
        bg: "bg-interactive-primary-pressed",
        icon: :bell
      }
    }.freeze

    # Default auto-dismiss timer. Pass `duration: 0` or `duration: nil` to
    # keep the toast until manually dismissed.
    DEFAULT_DURATION_MS = 5000

    def initialize(
      title:,
      body: nil,
      variant: :success,
      duration: DEFAULT_DURATION_MS,
      icon: nil,
      dismissible: true,
      id: nil,
      class: nil,
      **html_attrs
    )
      unless VARIANTS.key?(variant)
        raise ArgumentError, "#{self.class}: unknown variant :#{variant}. Valid: #{VARIANTS.keys.join(', ')}"
      end

      @title = title
      @body = body
      @variant = variant
      @duration = duration.to_i
      @icon_override = icon
      @dismissible = dismissible
      @id = id || "shipwright-toast-#{SecureRandom.hex(4)}"
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :title, :body, :id, :html_attrs

    def variant_bg
      VARIANTS.fetch(@variant)[:bg]
    end

    def variant_icon
      @icon_override || VARIANTS.fetch(@variant)[:icon]
    end

    def dismissible?
      @dismissible
    end

    def auto_dismiss?
      @duration.positive?
    end

    def duration_ms
      @duration
    end

    def wrapper_classes
      classes(
        "shipwright-toast flex items-start gap-3 p-3 pr-4 rounded-md font-sans",
        "bg-interactive-primary-pressed text-text-inverse shadow-lg",
        "min-w-64 max-w-md pointer-events-auto",
        "transition-all duration-300 ease-out",
        "data-[shipwright-toast-state=entering]:opacity-0 data-[shipwright-toast-state=entering]:translate-y-2",
        "data-[shipwright-toast-state=leaving]:opacity-0 data-[shipwright-toast-state=leaving]:translate-y-1",
        consumer: @class
      )
    end

    def icon_circle_classes
      "shrink-0 w-8 h-8 rounded-full flex items-center justify-center #{variant_bg} text-text-inverse"
    end

    # One-time-per-page Toast wiring. Rendered from both ToastComponent and
    # ToastContainerComponent so either on its own bootstraps the JS; the
    # `window.__shipwrightToastWired` guard makes duplicate renders a no-op.
    # Returns an html_safe String so it can be interpolated into ERB with `<%= %>`.
    # Stored in Ruby (not a partial) because the engine's app/views/ may not
    # be on the host application's view_paths lookup — the component template
    # lookup is handled by ViewComponent, but arbitrary partials are not.
    INIT_SCRIPT = <<~HTML.freeze
      <script data-shipwright-toast-init>
        (function () {
          if (window.__shipwrightToastWired) {
            if (typeof window.__shipwrightToastActivate === "function") {
              window.__shipwrightToastActivate();
            }
            return;
          }
          window.__shipwrightToastWired = true;

          function removeToast(el) {
            if (!el || el.dataset.shipwrightToastState === "leaving") return;
            el.dataset.shipwrightToastState = "leaving";
            el.addEventListener("transitionend", function handler() {
              el.removeEventListener("transitionend", handler);
              el.remove();
            }, { once: true });
            setTimeout(function () { if (el.isConnected) el.remove(); }, 600);
          }

          function activate(root) {
            var scope = root && root.querySelectorAll ? root : document;
            scope.querySelectorAll("[data-shipwright-toast]:not([data-shipwright-toast-active])").forEach(function (el) {
              el.dataset.shipwrightToastActive = "true";
              requestAnimationFrame(function () {
                requestAnimationFrame(function () {
                  el.dataset.shipwrightToastState = "visible";
                });
              });

              var duration = parseInt(el.dataset.shipwrightToastDuration, 10) || 0;
              if (duration > 0) {
                var remaining = duration;
                var start = Date.now();
                var timer = setTimeout(function () { removeToast(el); }, remaining);

                el.addEventListener("mouseenter", function () {
                  clearTimeout(timer);
                  remaining -= (Date.now() - start);
                });
                el.addEventListener("mouseleave", function () {
                  if (remaining <= 0) return;
                  start = Date.now();
                  timer = setTimeout(function () { removeToast(el); }, remaining);
                });
              }
            });
          }
          window.__shipwrightToastActivate = activate;

          document.addEventListener("click", function (event) {
            var btn = event.target.closest("[data-shipwright-toast-dismiss]");
            if (!btn) return;
            removeToast(btn.closest("[data-shipwright-toast]"));
          });

          if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", function () { activate(); });
          } else {
            activate();
          }

          document.addEventListener("turbo:load", function () { activate(); });
          document.addEventListener("turbo:frame-load", function (e) { activate(e.target); });
          document.addEventListener("turbo:before-stream-render", function () {
            requestAnimationFrame(function () { activate(); });
          });
        })();
      </script>
    HTML

    def self.init_script_html
      INIT_SCRIPT.html_safe
    end
  end
end

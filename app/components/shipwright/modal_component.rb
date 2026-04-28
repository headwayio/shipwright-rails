module Shipwright
  # Centered modal dialog. Built on the native `<dialog>` element so ESC,
  # focus trap, and the backdrop come for free. Sibling component to
  # SlideoutComponent — same conventions, different positioning.
  #
  # Matches Shipwright Pro's Modal organism.
  #
  # Usage:
  #   <%= render Shipwright::ModalComponent.new(id: "confirm", title: "Delete project?", subtitle: "This cannot be undone.") do |m| %>
  #     <p>All associated data will be permanently removed.</p>
  #
  #     <% m.with_action do %>
  #       <%= render Shipwright::ButtonComponent.new(hierarchy: :secondary,
  #             data: { shipwright_modal_close: "confirm" }) { "Cancel" } %>
  #     <% end %>
  #     <% m.with_action do %>
  #       <%= render Shipwright::ButtonComponent.new(hierarchy: :destructive) { "Delete" } %>
  #     <% end %>
  #   <% end %>
  #
  #   <%# Trigger lives anywhere — open via data attribute %>
  #   <button data-shipwright-modal-trigger="confirm">Open</button>
  #
  # Sizes (max-width):
  #   :sm = 360px, :md = 480px (default), :lg = 640px, :xl = 800px
  #
  # Options:
  #   id:             — DOM id; triggers reference it
  #   title:          — header title
  #   subtitle:       — optional subtitle below title
  #   size:           — :sm | :md (default) | :lg | :xl
  #   close_button:   — show the ✕ button (default true)
  #   initially_open: — render in its open state (Lookbook-friendly)
  #   header_class:   — extra classes merged onto header strip
  #   body_class:     — extra classes merged onto body region
  #   footer_class:   — extra classes merged onto actions footer
  #   class:          — extra classes merged onto outer <dialog>
  #
  # Slots:
  #   with_header    — replaces default title/subtitle block
  #   with_action    — footer buttons (multiple permitted)
  #   content        — body
  class ModalComponent < BaseComponent
    SIZES = {
      sm: "max-w-sm",   # 384px
      md: "max-w-md",   # 448px
      lg: "max-w-2xl",  # 672px
      xl: "max-w-4xl"   # 896px
    }.freeze

    renders_many :actions
    renders_one :header

    def initialize(
      id:,
      title: nil,
      subtitle: nil,
      size: :md,
      close_button: true,
      initially_open: false,
      header_class: nil,
      body_class: nil,
      footer_class: nil,
      class: nil,
      **html_attrs
    )
      unless SIZES.key?(size)
        raise ArgumentError, "#{self.class}: unknown size :#{size}. Valid: #{SIZES.keys.join(', ')}"
      end

      @id = id
      @title = title
      @subtitle = subtitle
      @size = size
      @close_button = close_button
      @initially_open = initially_open
      @header_class = header_class
      @body_class = body_class
      @footer_class = footer_class
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :id, :title, :subtitle, :html_attrs

    def close_button?
      @close_button
    end

    def initially_open?
      @initially_open
    end

    def has_default_header?
      title.present? || subtitle.present?
    end

    def has_header?
      header? || has_default_header? || close_button?
    end

    def size
      @size
    end

    # Outer <dialog> classes. UA-default `inset:0` for `:modal` dialogs is
    # left alone here — the dialog sits centered by default. We add a
    # max-w-* size cap and reset the UA's centering with our own flex
    # parent via `m-auto`. (See dialog-modal-ua-inset-overrides-tailwind
    # skill for context on why centering needs explicit treatment.)
    def dialog_classes
      base = "shipwright-modal fixed inset-0 m-auto p-0 bg-transparent border-0 outline-none " \
             "max-h-[90vh] w-[calc(100vw-2rem)] " \
             "transition-[opacity,transform] duration-200 ease-out " \
             "backdrop:bg-background-inverse/40 backdrop:transition-opacity backdrop:duration-200 " \
             "data-[shipwright-modal-state=closed]:opacity-0 " \
             "data-[shipwright-modal-state=closed]:scale-95 " \
             "backdrop:data-[shipwright-modal-state=closed]:opacity-0"
      classes(base, SIZES.fetch(@size), consumer: @class)
    end

    def panel_classes
      "flex flex-col bg-background-primary rounded-lg shadow-xl overflow-clip font-sans text-text-primary max-h-[inherit]"
    end

    def header_classes
      classes(
        "relative flex items-start justify-between gap-4 p-sm border-b border-border-primary shrink-0 bg-background-secondary",
        consumer: @header_class
      )
    end

    def body_classes
      classes("flex-1 min-h-px overflow-y-auto p-sm", consumer: @body_class)
    end

    def footer_classes
      classes(
        "flex flex-col-reverse sm:flex-row sm:items-center sm:justify-end gap-xs p-sm border-t border-border-primary shrink-0",
        consumer: @footer_class
      )
    end

    def close_button_classes
      "shrink-0 inline-flex items-center justify-center w-8 h-8 rounded-full text-text-primary hover:bg-background-tertiary transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-interactive-primary-default"
    end

    INIT_SCRIPT = <<~HTML.freeze
      <script data-shipwright-modal-init>
        (function () {
          if (window.__shipwrightModalWired) return;
          window.__shipwrightModalWired = true;

          function open(dialog) {
            if (!dialog || dialog.open) return;
            if (typeof dialog.showModal === "function") dialog.showModal(); else dialog.setAttribute("open", "");
            requestAnimationFrame(function () {
              requestAnimationFrame(function () { dialog.dataset.shipwrightModalState = "open"; });
            });
          }

          function close(dialog) {
            if (!dialog || !dialog.open) return;
            dialog.dataset.shipwrightModalState = "closed";
            dialog.addEventListener("transitionend", function handler(e) {
              if (e.target !== dialog) return;
              dialog.removeEventListener("transitionend", handler);
              if (typeof dialog.close === "function") dialog.close(); else dialog.removeAttribute("open");
            });
            setTimeout(function () {
              if (dialog.open) dialog.close ? dialog.close() : dialog.removeAttribute("open");
            }, 300);
          }

          document.addEventListener("click", function (event) {
            var trigger = event.target.closest("[data-shipwright-modal-trigger]");
            if (trigger) {
              event.preventDefault();
              var id = trigger.getAttribute("data-shipwright-modal-trigger");
              open(document.getElementById(id));
              return;
            }

            var closer = event.target.closest("[data-shipwright-modal-close]");
            if (closer) {
              event.preventDefault();
              var closeId = closer.getAttribute("data-shipwright-modal-close");
              var dialog = closeId ? document.getElementById(closeId) : closer.closest("dialog.shipwright-modal");
              close(dialog);
              return;
            }

            // Backdrop click — UA reports the click target as the <dialog>
            // element when user clicks outside the panel area.
            var dialog = event.target.closest("dialog.shipwright-modal");
            if (dialog && event.target === dialog) close(dialog);
          });

          // Intercept ESC so our exit transition plays before close.
          document.addEventListener("cancel", function (event) {
            var dialog = event.target;
            if (!dialog.classList || !dialog.classList.contains("shipwright-modal")) return;
            event.preventDefault();
            close(dialog);
          });

          function activate() {
            document.querySelectorAll("dialog.shipwright-modal[data-initially-open]").forEach(function (d) {
              open(d);
              delete d.dataset.initiallyOpen;
            });
          }
          if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", activate);
          } else {
            activate();
          }
          document.addEventListener("turbo:load", activate);
        })();
      </script>
    HTML

    def self.init_script_html
      INIT_SCRIPT.html_safe
    end
  end
end

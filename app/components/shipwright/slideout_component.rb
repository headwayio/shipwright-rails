module Shipwright
  # Slideout / sheet panel that anchors to an edge of the viewport. Built
  # on the native `<dialog>` element so ESC-to-close, focus trapping, and
  # the backdrop are handled by the browser. Styled position overrides
  # `<dialog>`'s default center placement with a transform-driven slide
  # animation.
  #
  # Matches Shipwright Pro's Sheet organism.
  #
  # Usage:
  #   <%= render Shipwright::SlideoutComponent.new(id: "profile", title: "Edit profile", subtitle: "Update your info") do |s| %>
  #     <p>Body content goes here.</p>
  #
  #     <% s.with_action do %>
  #       <%= render Shipwright::ButtonComponent.new(hierarchy: :secondary,
  #             data: { shipwright_slideout_close: "profile" }) { "Cancel" } %>
  #     <% end %>
  #     <% s.with_action do %>
  #       <%= render Shipwright::ButtonComponent.new(hierarchy: :primary) { "Save" } %>
  #     <% end %>
  #   <% end %>
  #
  #   <%# A trigger lives outside the slideout — any element with
  #       data-shipwright-slideout-trigger="profile" opens the panel. %>
  #   <button data-shipwright-slideout-trigger="profile">Open</button>
  #
  # Options:
  #   id:            — DOM id; triggers reference it by this value.
  #   position:      — :right (default) | :left | :bottom
  #   title:         — optional header title
  #   subtitle:      — optional header subtitle
  #   close_button:  — show the circular ✕ button (default true)
  #   width:         — panel width for side positions (default "428px")
  #   initially_open:— render the dialog in its open state (useful in Lookbook)
  #
  # Slots:
  #   with_tab(label:, icon: nil, active: false, href: nil) — segmented nav
  #   with_action { ... }                                    — footer buttons
  #   with_header { ... }                                    — replaces default title/subtitle
  #   content                                                — body (main block)
  class SlideoutComponent < BaseComponent
    POSITIONS = %i[right left bottom].freeze
    DEFAULT_SIDE_WIDTH = "428px".freeze

    # Lightweight tab slot — data only; the component template renders it.
    class Tab < ViewComponent::Base
      attr_reader :label, :icon, :href, :active

      def initialize(label:, icon: nil, href: nil, active: false)
        @label = label
        @icon = icon
        @href = href
        @active = active
      end

      def call
        ""
      end
    end

    renders_many :tabs, Tab
    renders_many :actions
    renders_one :header

    def initialize(
      id:,
      position: :right,
      title: nil,
      subtitle: nil,
      close_button: true,
      width: nil,
      initially_open: false,
      class: nil,
      **html_attrs
    )
      unless POSITIONS.include?(position)
        raise ArgumentError, "#{self.class}: unknown position :#{position}. Valid: #{POSITIONS.join(', ')}"
      end

      @id = id
      @position = position
      @title = title
      @subtitle = subtitle
      @close_button = close_button
      @width = width || (bottom? ? nil : DEFAULT_SIDE_WIDTH)
      @initially_open = initially_open
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :id, :title, :subtitle, :html_attrs

    def position
      @position
    end

    def bottom?
      @position == :bottom
    end

    def left?
      @position == :left
    end

    def right?
      @position == :right
    end

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

    # Inline `style` for the panel — fixed width on side positions.
    def panel_style
      return nil unless @width
      "width: #{@width};"
    end

    # Classes for the <dialog> itself. We override dialog's default
    # centering via fixed positioning + transform. The `open` attribute
    # renders the dialog in its visible state; the JS uses showModal()
    # for proper modal behavior (backdrop, focus trap, ESC).
    def dialog_classes
      base = "shipwright-slideout fixed m-0 p-0 bg-transparent border-0 outline-none " \
             "max-w-none max-h-none w-auto h-auto " \
             "transition-transform duration-300 ease-out " \
             "backdrop:bg-background-inverse/25 backdrop:transition-opacity backdrop:duration-300"

      # IMPORTANT: <dialog>:modal gets UA inset:0 on all four sides when opened
      # via showModal(). Setting only one side (e.g. right-0) leaves the
      # opposite side (left:0) in place, so the panel stretches full-width or
      # anchors to the wrong edge. Explicitly clear the unused axis with
      # left-auto / right-auto / top-auto.
      position_base = case position
      when :right
        "top-0 right-0 bottom-0 left-auto h-full"
      when :left
        "top-0 left-0 bottom-0 right-auto h-full"
      when :bottom
        "left-0 right-0 bottom-0 top-auto w-full"
      end

      # Entry/exit slide state driven by data-shipwright-slideout-state.
      # Default (closed) state is translated off-screen; "open" removes it.
      slide_closed = case position
      when :right  then "data-[shipwright-slideout-state=closed]:translate-x-full"
      when :left   then "data-[shipwright-slideout-state=closed]:-translate-x-full"
      when :bottom then "data-[shipwright-slideout-state=closed]:translate-y-full"
      end

      classes(base, position_base, slide_closed, consumer: @class)
    end

    def panel_classes
      base = "flex flex-col bg-background-primary overflow-clip font-sans text-text-primary"

      shape = case position
      when :right, :left
        "h-full"
      when :bottom
        "w-full max-h-[90vh] rounded-t-lg"
      end

      "#{base} #{shape}"
    end

    def header_classes
      "relative flex items-start justify-between gap-4 p-sm border-b border-border-primary shrink-0"
    end

    def tabs_classes
      "flex flex-wrap gap-md px-sm border-b border-border-primary shrink-0"
    end

    def tab_item_classes(active)
      if active
        "inline-flex items-center gap-2xs py-md border-b-2 border-border-interactive text-text-primary font-medium"
      else
        "inline-flex items-center gap-2xs py-md border-b-2 border-transparent text-text-secondary hover:text-text-primary transition-colors"
      end
    end

    def body_classes
      "flex-1 min-h-px overflow-y-auto p-sm"
    end

    def footer_classes
      # Mobile-style stacked actions by default; tablet+ lays them out
      # horizontally. Bottom-positioned sheets always use the horizontal
      # right-aligned layout.
      if bottom?
        "flex items-center justify-end gap-xs p-sm border-t border-border-primary shrink-0"
      else
        "flex flex-col sm:flex-row sm:items-center sm:justify-end gap-xs p-sm border-t border-border-primary shrink-0"
      end
    end

    def close_button_classes
      "shrink-0 inline-flex items-center justify-center w-8 h-8 rounded-full text-text-primary hover:bg-background-secondary transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-interactive-primary-default"
    end

    # One-time-per-page wiring: opens via showModal() from any
    # [data-shipwright-slideout-trigger] element; closes via
    # [data-shipwright-slideout-close] or backdrop click. Syncs the
    # `data-shipwright-slideout-state` attribute for CSS transitions.
    INIT_SCRIPT = <<~HTML.freeze
      <script data-shipwright-slideout-init>
        (function () {
          if (window.__shipwrightSlideoutWired) return;
          window.__shipwrightSlideoutWired = true;

          function open(dialog) {
            if (!dialog || dialog.open) return;
            if (typeof dialog.showModal === "function") dialog.showModal(); else dialog.setAttribute("open", "");
            requestAnimationFrame(function () {
              requestAnimationFrame(function () { dialog.dataset.shipwrightSlideoutState = "open"; });
            });
          }

          function close(dialog) {
            if (!dialog || !dialog.open) return;
            dialog.dataset.shipwrightSlideoutState = "closed";
            dialog.addEventListener("transitionend", function handler(e) {
              if (e.target !== dialog) return;
              dialog.removeEventListener("transitionend", handler);
              if (typeof dialog.close === "function") dialog.close(); else dialog.removeAttribute("open");
            });
            setTimeout(function () {
              if (dialog.open) dialog.close ? dialog.close() : dialog.removeAttribute("open");
            }, 400);
          }

          document.addEventListener("click", function (event) {
            var trigger = event.target.closest("[data-shipwright-slideout-trigger]");
            if (trigger) {
              event.preventDefault();
              var id = trigger.getAttribute("data-shipwright-slideout-trigger");
              open(document.getElementById(id));
              return;
            }

            var closer = event.target.closest("[data-shipwright-slideout-close]");
            if (closer) {
              event.preventDefault();
              var closeId = closer.getAttribute("data-shipwright-slideout-close");
              var dialog = closeId ? document.getElementById(closeId) : closer.closest("dialog.shipwright-slideout");
              close(dialog);
              return;
            }

            // Backdrop click — target IS the dialog element itself when user
            // clicks outside the panel (because the panel sits inside the
            // dialog and receives click bubbling from its own children).
            var dialog = event.target.closest("dialog.shipwright-slideout");
            if (dialog && event.target === dialog) close(dialog);
          });

          // ESC key closes via <dialog> native behavior, but we still want
          // the slide-out transition to run. Intercept and do our own close.
          document.addEventListener("cancel", function (event) {
            var dialog = event.target;
            if (!dialog.classList || !dialog.classList.contains("shipwright-slideout")) return;
            event.preventDefault();
            close(dialog);
          });

          // Activate any slideouts marked data-initially-open on page load.
          function activate() {
            document.querySelectorAll("dialog.shipwright-slideout[data-initially-open]").forEach(function (d) {
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

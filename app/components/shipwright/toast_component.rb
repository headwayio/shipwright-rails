module Shipwright
  # Toast — an ephemeral notification that "pops up" from an edge of the
  # screen, stacks with other toasts, and removes itself after a configurable
  # timeout (or sticks until the user dismisses it).
  #
  # Typically rendered inside a ToastContainerComponent and appended via
  # Turbo Stream, or seeded on first page load via
  # Shipwright::FlashHelper#shipwright_flash_toasts.
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
    VARIANTS = {
      success: {
        bg: "bg-utility-positive-default",
        icon: :"thumbs-up"
      },
      error: {
        bg: "bg-utility-negative-default",
        icon: :"thumbs-down"
      },
      warning: {
        bg: "bg-utility-warning-default",
        icon: :"thumbs-up"
      },
      info: {
        bg: "bg-interactive-primary-default",
        icon: :"thumbs-up"
      },
      neutral: {
        bg: "bg-interactive-primary-pressed",
        icon: :"thumbs-up"
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
  end
end

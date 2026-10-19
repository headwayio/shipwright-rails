module Shipwright
  # Fixed-position region where Toasts stack. Render this once in your
  # application layout (near the closing </body>). Toasts appended to its
  # DOM id — typically via Turbo Stream — will stack and animate in.
  #
  # Usage:
  #   # In your layout — `flash:` seeds toasts from flash on page load:
  #   <%= render Shipwright::ToastContainerComponent.new(flash: flash) %>
  #
  #   # Equivalent, if you want control over the helper's options:
  #   <%= render Shipwright::ToastContainerComponent.new do %>
  #     <%= shipwright_flash_toasts %>
  #   <% end %>
  #
  #   # NOT equivalent — the toasts render OUTSIDE the fixed container and
  #   # end up at body flow position, usually below the fold:
  #   <%= render Shipwright::ToastContainerComponent.new %>
  #   <%= shipwright_flash_toasts %>
  #
  #   # In a controller action (with Turbo):
  #   respond_to do |format|
  #     format.turbo_stream do
  #       render turbo_stream: turbo_stream.append(
  #         Shipwright::ToastContainerComponent::DOM_ID,
  #         Shipwright::ToastComponent.new(title: "Saved", variant: :success)
  #       )
  #     end
  #   end
  #
  # Positions: :top_right (default), :top_left, :bottom_right, :bottom_left,
  #            :top_center, :bottom_center
  class ToastContainerComponent < BaseComponent
    DOM_ID = "shipwright-toasts".freeze

    POSITIONS = {
      top_right:     "top-4 right-4 items-end",
      top_left:      "top-4 left-4 items-start",
      bottom_right:  "bottom-4 right-4 items-end",
      bottom_left:   "bottom-4 left-4 items-start",
      top_center:    "top-4 left-1/2 -translate-x-1/2 items-center",
      bottom_center: "bottom-4 left-1/2 -translate-x-1/2 items-center"
    }.freeze

    def initialize(position: :top_right, id: DOM_ID, flash: nil, class: nil, **html_attrs)
      unless POSITIONS.key?(position)
        raise ArgumentError, "#{self.class}: unknown position :#{position}. Valid: #{POSITIONS.keys.join(', ')}"
      end

      @position = position
      @id = id
      @flash = flash
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :id, :html_attrs

    # Toasts must be CHILDREN of this element — it is `position: fixed`, so a
    # toast rendered as a sibling lays out at normal body flow position and is
    # typically far below the fold, while the container sits empty in the
    # corner. Nothing looks broken when you inspect the toast itself.
    #
    # Passing `flash:` is the shortest correct form; a block works too.
    def toast_content
      return content if content.present?
      return helpers.shipwright_flash_toasts(@flash) if @flash

      nil
    end

    def container_classes
      classes(
        "fixed z-50 flex flex-col gap-2 pointer-events-none",
        POSITIONS.fetch(@position),
        consumer: @class
      )
    end
  end
end

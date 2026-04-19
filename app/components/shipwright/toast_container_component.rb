module Shipwright
  # Fixed-position region where Toasts stack. Render this once in your
  # application layout (near the closing </body>). Toasts appended to its
  # DOM id — typically via Turbo Stream — will stack and animate in.
  #
  # Usage:
  #   # In your layout:
  #   <%= render Shipwright::ToastContainerComponent.new %>
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

    def initialize(position: :top_right, id: DOM_ID, class: nil, **html_attrs)
      unless POSITIONS.key?(position)
        raise ArgumentError, "#{self.class}: unknown position :#{position}. Valid: #{POSITIONS.keys.join(', ')}"
      end

      @position = position
      @id = id
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :id, :html_attrs

    def call
      content_tag :div,
        content,
        id: id,
        class: classes(
          "fixed z-50 flex flex-col gap-2 pointer-events-none",
          POSITIONS.fetch(@position),
          consumer: @class
        ),
        "aria-live": "polite",
        "aria-label": "Notifications",
        **@html_attrs
    end
  end
end

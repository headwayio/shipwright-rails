module Shipwright
  class ButtonGroupComponent < BaseComponent
    renders_many :buttons, ButtonComponent

    # Density — compact shares borders with negative margin overlap;
    # regular spaces buttons with a gap and keeps their individual borders.
    DENSITIES = {
      compact: "gap-0",
      regular: "gap-2xs"
    }.freeze

    # Orientation — horizontal row or vertical column
    ORIENTATIONS = {
      horizontal: "flex-row",
      vertical: "flex-col"
    }.freeze

    # Position-aware styling applied via Tailwind arbitrary child selectors.
    # This keeps ButtonComponent unaware of group context — the container
    # shapes its children based on first-child / last-child position.
    COMPACT_POSITIONING = {
      horizontal: "[&>button:not(:first-child):not(:last-child)]:rounded-none " \
                  "[&>button:first-child]:rounded-r-none " \
                  "[&>button:last-child]:rounded-l-none " \
                  "[&>button:not(:first-child)]:-ml-px " \
                  "[&>button:focus-visible]:z-10 " \
                  "[&>button]:relative",
      vertical: "[&>button:not(:first-child):not(:last-child)]:rounded-none " \
                "[&>button:first-child]:rounded-b-none " \
                "[&>button:last-child]:rounded-t-none " \
                "[&>button:not(:first-child)]:-mt-px " \
                "[&>button:focus-visible]:z-10 " \
                "[&>button]:relative"
    }.freeze

    def initialize(density: :compact, orientation: :horizontal, class: nil, **html_attrs)
      @density = density
      @orientation = orientation
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def container_classes
      classes(
        "inline-flex",
        ORIENTATIONS.fetch(@orientation) { |v| raise ArgumentError, "#{self.class}: unknown orientation :#{v}. Valid: #{ORIENTATIONS.keys.join(', ')}" },
        DENSITIES.fetch(@density) { |v| raise ArgumentError, "#{self.class}: unknown density :#{v}. Valid: #{DENSITIES.keys.join(', ')}" },
        compact? ? COMPACT_POSITIONING.fetch(@orientation) : nil,
        consumer: @class
      )
    end

    attr_reader :html_attrs

    private

    def compact?
      @density == :compact
    end
  end
end

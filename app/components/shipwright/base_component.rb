module Shipwright
  class BaseComponent < ViewComponent::Base
    # Class-level merger singleton — avoids cold cache per component instance.
    # Configured with Shipwright Pro's custom theme tokens so tailwind_merge
    # recognizes conflicts within color/radius groups (e.g., bg-interactive-primary-default
    # and bg-utility-negative-default are both color utilities and should conflict).
    MERGER = TailwindMerge::Merger.new(config: {
      theme: {
        "color" => %w[
          interactive-primary-default
          interactive-primary-hover
          interactive-primary-pressed
          interactive-secondary-default
          interactive-disable
          border-interactive
          border-inverse
          utility-neutral-default
          utility-information-default
          utility-positive-default
          utility-negative-default
          utility-warning-default
          text-primary
          text-inverse
          text-disabled
          background-primary
          background-secondary
        ],
        "radius" => %w[md]
      }
    }).freeze

    private

    # Merges component default classes with consumer overrides.
    # Consumer class is always applied LAST so it wins over defaults and conditionals.
    #
    # @param defaults [String] one or more class strings to merge
    # @param consumer [String, nil] consumer-provided class override (always wins)
    # @param conditionals [Hash] class_string => boolean pairs
    #
    # Usage:
    #   classes("px-sm py-2xs bg-interactive-primary-default", consumer: @class)
    #   classes("px-sm", "bg-interactive-primary-default": active?, consumer: @class)
    def classes(*defaults, consumer: nil, **conditionals)
      conditional = conditionals.select { |_, v| v }.keys.map(&:to_s).join(" ")
      combined = [*defaults.compact, conditional, consumer].reject { |s| s.to_s.strip.empty? }.join(" ")
      MERGER.merge(combined)
    end
  end
end

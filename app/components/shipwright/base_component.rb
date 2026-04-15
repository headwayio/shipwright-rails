module Shipwright
  class BaseComponent < ViewComponent::Base
    # Class-level merger singleton — avoids cold cache per component instance.
    # Configured with custom theme tokens so tailwind_merge recognizes
    # bg-primary, text-surface, etc. as conflicting within their groups.
    MERGER = TailwindMerge::Merger.new(config: {
      theme: {
        "color" => %w[primary secondary surface on-surface muted destructive],
        "radius" => %w[default sm lg full]
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
    #   classes("px-4 py-2 bg-primary", consumer: @class)
    #   classes("px-4 py-2", "bg-primary": active?, "opacity-50": disabled?, consumer: @class)
    def classes(*defaults, consumer: nil, **conditionals)
      conditional = conditionals.select { |_, v| v }.keys.map(&:to_s).join(" ")
      combined = [*defaults.compact, conditional, consumer].reject { |s| s.to_s.strip.empty? }.join(" ")
      MERGER.merge(combined)
    end
  end
end

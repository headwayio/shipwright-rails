module Shipwright
  class RadioGroupComponentPreview < Lookbook::Preview
    # @label Horizontal (required)
    def horizontal
      render(Shipwright::RadioGroupComponent.new(name: "plan_h", label: "Group Label", required: true)) do |g|
        g.with_option(value: "free", label: "Label")
        g.with_option(value: "pro", label: "Label", checked: true)
        g.with_option(value: "team", label: "Label")
      end
    end

    # @label Vertical (required)
    def vertical
      render(Shipwright::RadioGroupComponent.new(name: "plan_v", label: "Group Label", required: true, layout: :vertical)) do |g|
        g.with_option(value: "free", label: "Label")
        g.with_option(value: "pro", label: "Label", checked: true)
        g.with_option(value: "team", label: "Label")
      end
    end

    # @label With captions
    def with_captions
      render(Shipwright::RadioGroupComponent.new(name: "plan_c", label: "Plan", layout: :vertical)) do |g|
        g.with_option(value: "free", label: "Free", caption: "For getting started")
        g.with_option(value: "pro", label: "Pro", caption: "Most popular", checked: true)
        g.with_option(value: "team", label: "Team", caption: "For organizations")
      end
    end

    # @label One disabled option
    def disabled_option
      render(Shipwright::RadioGroupComponent.new(name: "plan_d", label: "Plan", layout: :vertical)) do |g|
        g.with_option(value: "free", label: "Free")
        g.with_option(value: "pro", label: "Pro", checked: true)
        g.with_option(value: "team", label: "Team", caption: "Unavailable in your region", disabled: true)
      end
    end
  end
end

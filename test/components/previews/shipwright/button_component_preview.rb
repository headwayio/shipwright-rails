module Shipwright
  class ButtonComponentPreview < Lookbook::Preview
    # @label Primary (default)
    def primary
      render Shipwright::ButtonComponent.new(hierarchy: :primary) { "Primary" }
    end

    # @label Secondary
    def secondary
      render Shipwright::ButtonComponent.new(hierarchy: :secondary) { "Secondary" }
    end

    # @label Tertiary
    def tertiary
      render Shipwright::ButtonComponent.new(hierarchy: :tertiary) { "Tertiary" }
    end

    # @label Destructive
    def destructive
      render Shipwright::ButtonComponent.new(hierarchy: :destructive) { "Delete" }
    end

    # @label All Hierarchies
    def all_hierarchies
      render_with_template
    end

    # @label All Sizes
    def all_sizes
      render_with_template
    end

    # @label Pill Shape
    def pill_shape
      render_with_template
    end

    # @label Icon Only
    def icon_only
      render_with_template
    end

    # @label Disabled
    def disabled
      render_with_template
    end

    # @label With Class Override
    def with_class_override
      render Shipwright::ButtonComponent.new(class: "w-full") { "Full Width" }
    end
  end
end

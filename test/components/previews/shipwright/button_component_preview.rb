module Shipwright
  class ButtonComponentPreview < Lookbook::Preview
    # @label Primary (default)
    def primary
      render Shipwright::ButtonComponent.new(variant: :primary) { "Primary Button" }
    end

    # @label Secondary
    def secondary
      render Shipwright::ButtonComponent.new(variant: :secondary) { "Secondary Button" }
    end

    # @label Outline
    def outline
      render Shipwright::ButtonComponent.new(variant: :outline) { "Outline Button" }
    end

    # @label Small
    def small
      render Shipwright::ButtonComponent.new(size: :sm) { "Small Button" }
    end

    # @label Large
    def large
      render Shipwright::ButtonComponent.new(size: :lg) { "Large Button" }
    end

    # @label All Variants
    def all_variants
      render_with_template
    end

    # @label With Class Override
    def with_class_override
      render Shipwright::ButtonComponent.new(class: "w-full") { "Full Width" }
    end
  end
end

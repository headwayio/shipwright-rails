module Shipwright
  class IconComponentPreview < Lookbook::Preview
    # @label Default (info, md)
    def default
      render Shipwright::IconComponent.new(name: :info)
    end

    # @label All Icons
    def gallery
      render_with_template
    end

    # @label Sizes
    def sizes
      render_with_template
    end

    # @label Colored (via text-*)
    def colored
      render_with_template
    end

    # @label With aria-label (non-decorative)
    def with_aria_label
      render Shipwright::IconComponent.new(name: :info, "aria-label": "More information")
    end
  end
end

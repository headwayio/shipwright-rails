module Shipwright
  class BrandIconComponentPreview < Lookbook::Preview
    # @label Gallery (all installed brand icons)
    def gallery
      render_with_template
    end

    # @label Sizes
    def sizes
      render_with_template
    end

    # @label Rounded
    def rounded
      render_with_template
    end

    # @label Empty state (no Figma export yet)
    def empty_state
      render_with_template
    end
  end
end

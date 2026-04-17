module Shipwright
  class ButtonGroupComponentPreview < Lookbook::Preview
    # @label Compact Horizontal (default)
    def compact_horizontal
      render_with_template
    end

    # @label Compact Vertical
    def compact_vertical
      render_with_template
    end

    # @label Regular Horizontal
    def regular_horizontal
      render_with_template
    end

    # @label Regular Vertical
    def regular_vertical
      render_with_template
    end

    # @label All Hierarchies
    def all_hierarchies
      render_with_template
    end

    # @label Icon Only
    def icon_only
      render_with_template
    end

    # @label Count Variations
    def counts
      render_with_template
    end
  end
end

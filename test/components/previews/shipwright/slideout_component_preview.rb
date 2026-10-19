module Shipwright
  class SlideoutComponentPreview < Lookbook::Preview
    # @label Right (default)
    def right
      render_with_template
    end

    # @label Left
    def left
      render_with_template
    end

    # @label Bottom
    def bottom
      render_with_template
    end

    # @label With tabs
    def with_tabs
      render_with_template
    end

    # @label No header
    def no_header
      render_with_template
    end

    # @label Always open (inline preview)
    def always_open
      render_with_template
    end
  end
end

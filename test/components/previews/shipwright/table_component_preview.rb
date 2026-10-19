module Shipwright
  class TableComponentPreview < Lookbook::Preview
    # @label Default
    def default
      render_with_template
    end

    # @label Selectable + sortable
    def selectable_sortable
      render_with_template
    end

    # @label Rich cells (avatars, badges, progress)
    def rich_cells
      render_with_template
    end

    # @label Striped rows
    def striped
      render_with_template
    end

    # @label Compact density
    def compact
      render_with_template
    end
  end
end

module Shipwright
  class CheckboxComponentPreview < Lookbook::Preview
    # @label Default
    def default
      render Shipwright::CheckboxComponent.new(name: "default", label: "Label")
    end

    # @label Checked
    def checked
      render Shipwright::CheckboxComponent.new(name: "checked", label: "Label", checked: true)
    end

    # @label With caption
    def with_caption
      render Shipwright::CheckboxComponent.new(
        name: "captioned",
        label: "Email me updates",
        caption: "No more than once a week.",
        checked: true
      )
    end

    # @label States
    def states
      render_with_template
    end

    # @label Variants
    def variants
      render_with_template
    end

    # @label Label position
    def label_positions
      render_with_template
    end

    # @label Group
    def group
      render_with_template
    end
  end
end

module Shipwright
  class RadioComponentPreview < Lookbook::Preview
    # @label Default (unchecked)
    def default
      render(Shipwright::RadioComponent.new(name: "plan", value: "free", label: "Label", caption: "Caption"))
    end

    # @label Checked
    def checked
      render(Shipwright::RadioComponent.new(name: "plan", value: "pro", label: "Label", caption: "Caption", checked: true))
    end

    # @label Disabled
    def disabled
      render(Shipwright::RadioComponent.new(name: "plan", value: "team", label: "Label", caption: "Caption", disabled: true))
    end

    # @label Disabled + checked
    def disabled_checked
      render(Shipwright::RadioComponent.new(name: "plan", value: "x", label: "Label", caption: "Caption", disabled: true, checked: true))
    end

    # @label Large
    def large
      render(Shipwright::RadioComponent.new(name: "plan", value: "x", label: "Label", caption: "Caption", size: :md))
    end

    # @label Label on left
    def label_left
      render(Shipwright::RadioComponent.new(name: "plan", value: "x", label: "Label", caption: "Caption", label_position: :left))
    end

    # @label Destructive
    def destructive
      render(Shipwright::RadioComponent.new(name: "plan", value: "x", label: "Label", variant: :destructive, checked: true))
    end

    # @label Grid of states
    def grid
      render_with_template
    end
  end
end

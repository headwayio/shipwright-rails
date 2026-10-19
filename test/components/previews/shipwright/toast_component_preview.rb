module Shipwright
  class ToastComponentPreview < Lookbook::Preview
    # @label Success
    def success
      render(Shipwright::ToastComponent.new(
        title: "Toast Title",
        body: "Place holder text for this toast. Enter text here",
        variant: :success
      ))
    end

    # @label Error
    def error
      render(Shipwright::ToastComponent.new(title: "Something went wrong", body: "Please try again", variant: :error))
    end

    # @label Warning
    def warning
      render(Shipwright::ToastComponent.new(title: "Heads up", body: "You're nearing your quota", variant: :warning))
    end

    # @label Info
    def info
      render(Shipwright::ToastComponent.new(title: "Did you know?", body: "You can drag to reorder items", variant: :info))
    end

    # @label Neutral
    def neutral
      render(Shipwright::ToastComponent.new(title: "Syncing", body: "Just a moment…", variant: :neutral))
    end

    # @label Title only
    def title_only
      render(Shipwright::ToastComponent.new(title: "Saved", variant: :success))
    end

    # @label Sticky (no auto-dismiss)
    def sticky
      render(Shipwright::ToastComponent.new(title: "Sticky", body: "Click ✕ to dismiss", duration: 0))
    end

    # @label Custom icon override
    def custom_icon
      render(Shipwright::ToastComponent.new(
        title: "New message",
        body: "From Wendy Sullivan",
        variant: :info,
        icon: :mail
      ))
    end

    # @label Container + live demo
    def container
      render_with_template
    end
  end
end

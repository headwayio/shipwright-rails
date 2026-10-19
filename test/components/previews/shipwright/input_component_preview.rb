module Shipwright
  class InputComponentPreview < Lookbook::Preview
    # @label Default
    def default
      render(Shipwright::InputComponent.new(
        name: "email", label: "Label", caption: "Caption",
        placeholder: "giorgio@armani.com",
        leading_icon: :search, trailing_icon: :"arrow-right"
      ))
    end

    # @label With value
    def with_value
      render(Shipwright::InputComponent.new(
        name: "email", label: "Label", caption: "Caption",
        value: "giorgio@armani.com",
        leading_icon: :search, trailing_icon: :"arrow-right"
      ))
    end

    # @label Disabled
    def disabled
      render(Shipwright::InputComponent.new(
        name: "email", label: "Label", caption: "Caption",
        value: "giorgio@armani.com", disabled: true,
        leading_icon: :search, trailing_icon: :"arrow-right"
      ))
    end

    # @label Success
    def success
      render(Shipwright::InputComponent.new(
        name: "email", label: "Label", caption: "Looks good",
        value: "giorgio@armani.com", variant: :success,
        leading_icon: :search, trailing_icon: :"arrow-right"
      ))
    end

    # @label Error
    def error
      render(Shipwright::InputComponent.new(
        name: "email", label: "Label",
        value: "giorgio@armani.com",
        error: "Please enter a valid email",
        leading_icon: :search, trailing_icon: :"arrow-right"
      ))
    end

    # @label No icons
    def no_icons
      render(Shipwright::InputComponent.new(
        name: "name", label: "Full name", caption: "First and last",
        placeholder: "Alex Johnson"
      ))
    end

    # @label Password
    def password
      render(Shipwright::InputComponent.new(
        name: "pw", type: :password, label: "Password",
        caption: "At least 12 characters",
        placeholder: "••••••••", leading_icon: :lock
      ))
    end

    # @label With HTML5 validation
    def with_html5_validation
      render_with_template
    end

    # @label Grid
    def grid
      render_with_template
    end
  end
end

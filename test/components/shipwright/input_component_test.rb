require "test_helper"

class Shipwright::InputComponentTest < ViewComponent::TestCase
  def test_renders_label_and_input
    render_inline(Shipwright::InputComponent.new(name: "email", label: "Email"))

    assert_text "Email"
    assert_selector "input[type='text'][name='email']"
  end

  def test_caption_displayed_below
    render_inline(Shipwright::InputComponent.new(name: "email", caption: "Help text"))

    assert_text "Help text"
  end

  def test_placeholder_rendered
    render_inline(Shipwright::InputComponent.new(name: "email", placeholder: "giorgio@armani.com"))

    assert_selector "input[placeholder='giorgio@armani.com']"
  end

  def test_value_rendered
    render_inline(Shipwright::InputComponent.new(name: "email", value: "hi@there.com"))

    assert_selector "input[value='hi@there.com']"
  end

  def test_type_applied
    render_inline(Shipwright::InputComponent.new(name: "pw", type: :password))

    assert_selector "input[type='password']"
  end

  def test_leading_and_trailing_icons
    render_inline(Shipwright::InputComponent.new(name: "q", leading_icon: :search, trailing_icon: :"arrow-right"))

    # Two icons inside the field row
    assert_selector "svg", minimum: 2
  end

  def test_disabled_adds_attribute
    render_inline(Shipwright::InputComponent.new(name: "x", disabled: true))

    assert_selector "input[disabled]"
  end

  def test_readonly_adds_attribute
    render_inline(Shipwright::InputComponent.new(name: "x", readonly: true))

    assert_selector "input[readonly]"
  end

  def test_required_adds_attribute
    render_inline(Shipwright::InputComponent.new(name: "x", required: true))

    assert_selector "input[required]"
  end

  def test_destructive_variant_colors_border
    render_inline(Shipwright::InputComponent.new(name: "x", variant: :destructive))

    assert_includes rendered_content, "utility-negative-default"
  end

  def test_success_variant_colors_border
    render_inline(Shipwright::InputComponent.new(name: "x", variant: :success))

    assert_includes rendered_content, "utility-positive-default"
  end

  def test_error_message_forces_destructive_variant
    render_inline(Shipwright::InputComponent.new(name: "x", error: "Something broke"))

    assert_includes rendered_content, "utility-negative-default"
    assert_text "Something broke"
  end

  def test_error_sets_aria_invalid
    render_inline(Shipwright::InputComponent.new(name: "x", error: "Broken"))

    assert_selector "input[aria-invalid='true']"
  end

  def test_error_message_linked_via_aria_describedby
    render_inline(Shipwright::InputComponent.new(name: "x", error: "Broken"))

    html = rendered_content
    assert_match(/aria-describedby="([^"]+)"/, html)
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) { Shipwright::InputComponent.new(name: "x", variant: :weird) }
  end

  def test_raises_on_invalid_type
    assert_raises(ArgumentError) { Shipwright::InputComponent.new(name: "x", type: :color) }
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::InputComponent.new(name: "x", class: "my-8"))

    assert_selector "div.my-8"
  end

  def test_html5_validation_attrs_forwarded_to_input
    render_inline(Shipwright::InputComponent.new(
      name: "u", pattern: "[a-z]+", minlength: 3, maxlength: 24,
      autocomplete: "username", inputmode: "text"
    ))

    assert_selector "input[pattern='[a-z]+'][minlength='3'][maxlength='24'][autocomplete='username'][inputmode='text']"
  end

  def test_numeric_validation_attrs_forwarded
    render_inline(Shipwright::InputComponent.new(name: "n", type: :number, min: 1, max: 100, step: 5))

    assert_selector "input[type='number'][min='1'][max='100'][step='5']"
  end

  def test_label_associates_with_input_via_for
    render_inline(Shipwright::InputComponent.new(name: "my_field", label: "My Field"))

    html = rendered_content
    match = html.match(/\sid="(shipwright-input-[^"]+)"/)
    assert match, "expected input to have an id"
    id = match[1]
    assert_match(/<label[^>]+for="#{Regexp.escape(id)}"/, html)
  end
end

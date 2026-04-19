require "test_helper"

class Shipwright::ToastContainerComponentTest < ViewComponent::TestCase
  def test_renders_with_default_dom_id
    render_inline(Shipwright::ToastContainerComponent.new)

    assert_selector "##{Shipwright::ToastContainerComponent::DOM_ID}"
  end

  def test_custom_id_respected
    render_inline(Shipwright::ToastContainerComponent.new(id: "custom-toasts"))

    assert_selector "#custom-toasts"
  end

  def test_position_default_is_top_right
    render_inline(Shipwright::ToastContainerComponent.new)

    assert_includes rendered_content, "top-4 right-4"
  end

  def test_position_bottom_left
    render_inline(Shipwright::ToastContainerComponent.new(position: :bottom_left))

    assert_includes rendered_content, "bottom-4 left-4"
  end

  def test_raises_on_invalid_position
    assert_raises(ArgumentError) { Shipwright::ToastContainerComponent.new(position: :middle) }
  end

  def test_renders_string_content
    render_inline(Shipwright::ToastContainerComponent.new) { "hello" }

    assert_text "hello"
  end

  def test_has_live_region_attributes
    render_inline(Shipwright::ToastContainerComponent.new)

    assert_selector "[aria-live='polite'][aria-label='Notifications']"
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::ToastContainerComponent.new(class: "my-8"))

    assert_selector "div.my-8"
  end
end

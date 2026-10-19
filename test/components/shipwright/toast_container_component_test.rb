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
  # The container is `position: fixed`. A toast rendered as a SIBLING of it
  # still appears in the DOM with correct styles, but lays out at normal body
  # flow position — usually far below the fold — while the container sits
  # empty in the corner. `flash:` makes the correct form the short one.
  def test_flash_toasts_render_inside_the_container
    render_inline(Shipwright::ToastContainerComponent.new(flash: { "alert" => "Not found" }))

    assert_selector "##{Shipwright::ToastContainerComponent::DOM_ID} [data-shipwright-toast]"
    assert_text "Not found"
  end

  def test_flash_entries_the_mapping_ignores_produce_no_toast
    render_inline(Shipwright::ToastContainerComponent.new(flash: { "form_id" => "user" }))

    assert_no_selector "[data-shipwright-toast]"
  end

  def test_block_content_still_renders_inside_the_container
    render_inline(Shipwright::ToastContainerComponent.new) do
      "<div data-shipwright-toast>Saved</div>".html_safe
    end

    assert_selector "##{Shipwright::ToastContainerComponent::DOM_ID} [data-shipwright-toast]"
  end

  def test_block_content_wins_over_flash
    render_inline(Shipwright::ToastContainerComponent.new(flash: { "alert" => "From flash" })) do
      "<div data-shipwright-toast>From block</div>".html_safe
    end

    assert_text "From block"
    assert_no_text "From flash"
  end

  # The Turbo Stream path appends into the container by DOM id, so an empty
  # container on first paint is a legitimate state, not a mistake.
  def test_renders_empty_without_flash_or_block
    render_inline(Shipwright::ToastContainerComponent.new)

    assert_selector "##{Shipwright::ToastContainerComponent::DOM_ID}"
    assert_no_selector "[data-shipwright-toast]"
  end
end

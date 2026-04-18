require "test_helper"

class Shipwright::BreadcrumbComponentTest < ViewComponent::TestCase
  def test_renders_nav_with_aria_label
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/") { "Home" }
      crumb.with_item { "Current" }
    end

    assert_selector "nav[aria-label='Breadcrumb']"
  end

  def test_renders_ordered_list
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/") { "Home" }
      crumb.with_item { "Current" }
    end

    assert_selector "nav ol"
    assert_selector "nav ol li", count: 2
  end

  def test_item_with_href_renders_link
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/products") { "Products" }
      crumb.with_item { "Widget" }
    end

    assert_selector "a[href='/products']", text: "Products"
  end

  def test_item_without_href_renders_span
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item { "Current page" }
    end

    assert_no_selector "a", text: "Current page"
    assert_selector "span", text: "Current page"
  end

  def test_last_item_marked_as_current_via_aria
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/") { "Home" }
      crumb.with_item(href: "/products") { "Products" }
      crumb.with_item { "Widget" }
    end

    assert_selector "[aria-current='page']", text: "Widget"
  end

  def test_separator_between_items_but_not_after_last
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/") { "Home" }
      crumb.with_item(href: "/products") { "Products" }
      crumb.with_item { "Widget" }
    end

    # 3 items = 2 separators
    assert_selector "[data-breadcrumb-separator]", count: 2
  end

  def test_default_separator_is_chevron
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/") { "Home" }
      crumb.with_item { "B" }
    end

    # Default separator uses chevron-right IconComponent
    assert_selector "[data-breadcrumb-separator] svg"
  end

  def test_slash_separator
    render_inline(Shipwright::BreadcrumbComponent.new(separator: :slash)) do |crumb|
      crumb.with_item(href: "/") { "Home" }
      crumb.with_item { "B" }
    end

    assert_selector "[data-breadcrumb-separator]", text: "/"
  end

  def test_item_with_icon
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/", icon: :home) { "Home" }
      crumb.with_item { "Current" }
    end

    # Home icon renders as svg inside first item
    assert_selector "li:first-child svg"
  end

  def test_single_item_has_no_separator
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/", icon: :home) { "Home" }
    end

    assert_no_selector "[data-breadcrumb-separator]"
  end

  def test_consumer_class_merges
    render_inline(Shipwright::BreadcrumbComponent.new(class: "my-4")) do |crumb|
      crumb.with_item { "A" }
    end

    assert_selector "nav.my-4"
  end

  def test_passes_html_attributes_to_nav
    render_inline(Shipwright::BreadcrumbComponent.new(id: "top-nav")) do |crumb|
      crumb.with_item { "A" }
    end

    assert_selector "nav#top-nav"
  end

  def test_raises_on_invalid_separator
    assert_raises(ArgumentError) do
      render_inline(Shipwright::BreadcrumbComponent.new(separator: :bullet)) do |crumb|
        crumb.with_item { "A" }
      end
    end
  end

  def test_link_styling_applied
    render_inline(Shipwright::BreadcrumbComponent.new) do |crumb|
      crumb.with_item(href: "/") { "Home" }
      crumb.with_item { "Current" }
    end

    html = rendered_content
    assert_includes html, "hover:"
    assert_includes html, "text-sm"
  end
end

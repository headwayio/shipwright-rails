require "test_helper"

class Shipwright::PaginationComponentTest < ViewComponent::TestCase
  def url(p) = "?page=#{p}"

  def test_renders_nav_with_aria_label
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 1, total_pages: 5, page_url: ->(p) { url(p) }
    ))

    assert_selector "nav[aria-label='Pagination']"
  end

  def test_numeric_variant_renders_page_links
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 2, total_pages: 5, page_url: ->(p) { url(p) }
    ))

    (1..5).each do |p|
      if p == 2
        assert_selector "[aria-current='page']", text: p.to_s
      else
        assert_selector "a[href='?page=#{p}']", text: p.to_s
      end
    end
  end

  def test_series_passed_explicitly_is_used
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 2, total_pages: 10,
      series: [1, 2, 3, :gap, 9, 10],
      page_url: ->(p) { url(p) }
    ))

    # 5 page entries (1, 2 current, 3, 9, 10) — filter to elements carrying page-number text
    %w[1 3 9 10].each { |p| assert_selector "a[aria-label='Go to page #{p}']" }
    assert_selector "[aria-current='page']", text: "2"
    assert_text "…"
  end

  def test_auto_series_truncates_long_ranges
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 5, total_pages: 20, page_url: ->(p) { url(p) }
    ))

    # First and last pages always present
    assert_selector "a[href='?page=1']", text: "1"
    assert_selector "a[href='?page=20']", text: "20"
    # Ellipsis between non-contiguous ranges
    assert_text "…"
  end

  def test_pagy_style_series_normalizes_strings
    # Pagy returns strings for numbers and :gap for ellipsis
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 2, total_pages: 10,
      series: ["1", "2", "3", :gap, "9", "10"],
      page_url: ->(p) { url(p) }
    ))

    assert_selector "a[href='?page=1']", text: "1"
    assert_selector "a[href='?page=10']", text: "10"
  end

  def test_previous_button_disabled_on_first_page
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 1, total_pages: 5, page_url: ->(p) { url(p) }
    ))

    assert_selector "[aria-label='Previous page'][aria-disabled='true']"
  end

  def test_next_button_disabled_on_last_page
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 5, total_pages: 5, page_url: ->(p) { url(p) }
    ))

    assert_selector "[aria-label='Next page'][aria-disabled='true']"
  end

  def test_previous_and_next_link_to_adjacent_pages
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 3, total_pages: 5, page_url: ->(p) { url(p) }
    ))

    assert_selector "a[aria-label='Previous page'][href='?page=2']"
    assert_selector "a[aria-label='Next page'][href='?page=4']"
  end

  def test_simple_variant_shows_label_and_arrows_only
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 1, total_pages: 10, variant: :simple, page_url: ->(p) { url(p) }
    ))

    assert_text "Page 1 of 10"
    assert_selector "[aria-label='Previous page']"
    assert_selector "[aria-label='Next page']"
    assert_no_selector "a", text: "5" # no numeric buttons
  end

  def test_simple_variant_custom_label
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 1, total_pages: 10, variant: :simple,
      label: "Showing 1–10 of 100", page_url: ->(p) { url(p) }
    ))

    assert_text "Showing 1–10 of 100"
  end

  def test_label_position_hidden_hides_label
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 1, total_pages: 10, variant: :simple,
      label_position: :hidden, page_url: ->(p) { url(p) }
    ))

    refute_includes rendered_content, "Page 1 of 10"
  end

  def test_rows_per_page_renders_select_with_options
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 1, total_pages: 5,
      rows_per_page: 25, rows_per_page_options: [10, 25, 50],
      page_url: ->(p) { url(p) }
    ))

    assert_text "Rows per page:"
    assert_selector "select[data-pagination-rows-per-page]"
    assert_selector "select option[value='25'][selected]"
    assert_selector "select option[value='10']"
    assert_selector "select option[value='50']"
  end

  def test_raises_on_invalid_variant
    assert_raises(ArgumentError) do
      Shipwright::PaginationComponent.new(
        current_page: 1, total_pages: 5, variant: :weird, page_url: ->(p) { url(p) }
      )
    end
  end

  def test_raises_on_invalid_label_position
    assert_raises(ArgumentError) do
      Shipwright::PaginationComponent.new(
        current_page: 1, total_pages: 5, label_position: :top, page_url: ->(p) { url(p) }
      )
    end
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 1, total_pages: 5, class: "my-8", page_url: ->(p) { url(p) }
    ))

    assert_selector "nav.my-8"
  end

  def test_current_page_not_a_link
    render_inline(Shipwright::PaginationComponent.new(
      current_page: 2, total_pages: 5, page_url: ->(p) { url(p) }
    ))

    # current page renders as span, not anchor
    assert_no_selector "a[href='?page=2']"
    assert_selector "[aria-current='page']", text: "2"
  end
end

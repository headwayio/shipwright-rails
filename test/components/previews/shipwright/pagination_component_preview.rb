module Shipwright
  class PaginationComponentPreview < Lookbook::Preview
    URL = ->(p) { "#page-#{p}" }

    # @label Numeric (pill)
    def numeric
      render(Shipwright::PaginationComponent.new(
        current_page: 2, total_pages: 10,
        series: [1, 2, 3, 4, 5, :gap, 9, 10],
        page_url: URL
      ))
    end

    # @label Numeric (loose — separate buttons)
    def numeric_loose
      render(Shipwright::PaginationComponent.new(
        current_page: 2, total_pages: 10,
        series: [1, 2, 3, 4, 5, :gap, 9, 10],
        variant: :numeric_loose,
        page_url: URL
      ))
    end

    # @label Simple — label left
    def simple_left
      render(Shipwright::PaginationComponent.new(
        current_page: 1, total_pages: 10, variant: :simple, page_url: URL
      ))
    end

    # @label Simple — label right
    def simple_right
      render(Shipwright::PaginationComponent.new(
        current_page: 1, total_pages: 10, variant: :simple, label_position: :right, page_url: URL
      ))
    end

    # @label Simple — centered
    def simple_center
      render(Shipwright::PaginationComponent.new(
        current_page: 1, total_pages: 10, variant: :simple, label_position: :center, page_url: URL
      ))
    end

    # @label With rows-per-page
    def rows_per_page
      render(Shipwright::PaginationComponent.new(
        current_page: 1, total_pages: 10,
        rows_per_page: 10, rows_per_page_options: [10, 25, 50, 100],
        rows_per_page_url: ->(n) { "#per=#{n}" },
        page_url: URL
      ))
    end

    # @label First page (prev disabled)
    def first_page
      render(Shipwright::PaginationComponent.new(
        current_page: 1, total_pages: 5, page_url: URL
      ))
    end

    # @label Last page (next disabled)
    def last_page
      render(Shipwright::PaginationComponent.new(
        current_page: 5, total_pages: 5, page_url: URL
      ))
    end

    # @label Auto-series (long range)
    def auto_series
      render(Shipwright::PaginationComponent.new(
        current_page: 12, total_pages: 50, page_url: URL
      ))
    end

    # @label Pagy integration example
    def pagy_example
      render_with_template
    end
  end
end

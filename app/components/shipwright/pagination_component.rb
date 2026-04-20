module Shipwright
  # Pagination — numeric page buttons or a simple prev/next control with an
  # optional "Page X of Y" label and a "Rows per page" selector. Designed
  # to plug into any paginator (Pagy, Kaminari, custom) by taking plain
  # props and a URL generator Proc.
  #
  # Usage (Pagy):
  #   <%= render Shipwright::PaginationComponent.new(
  #     current_page: @pagy.page,
  #     total_pages:  @pagy.pages,
  #     series:       @pagy.series,              # [1, 2, :gap, 9, 10]
  #     page_url:     ->(p) { url_for(page: p) }
  #   ) %>
  #
  # Usage (anything with current + total):
  #   <%= render Shipwright::PaginationComponent.new(
  #     current_page: 2, total_pages: 10,
  #     page_url: ->(p) { url_for(page: p) }
  #   ) %>
  #
  # Variants:
  #   :numeric         — ← 1 2 3 … 9 10 → wrapped in a single bordered pill
  #   :numeric_loose   — same content but each button is separately bordered
  #   :simple          — just "Page X of Y" + prev/next arrows
  #
  # Add a rows-per-page selector by passing `rows_per_page:` and
  # `rows_per_page_options:` (and a `rows_per_page_url:` Proc). The selector
  # is a plain native `<select>` wrapped to match the design.
  class PaginationComponent < BaseComponent
    VARIANTS = %i[numeric numeric_loose simple].freeze
    LABEL_POSITIONS = %i[left right center hidden].freeze

    # Default window when auto-generating a series. Shows first + last pages
    # plus a window around the current page.
    WINDOW = 1

    def initialize(
      current_page:,
      total_pages:,
      page_url:,
      series: nil,
      variant: :numeric,
      label: nil,
      label_position: :left,
      rows_per_page: nil,
      rows_per_page_options: [10, 25, 50, 100],
      rows_per_page_url: nil,
      class: nil,
      **html_attrs
    )
      unless VARIANTS.include?(variant)
        raise ArgumentError, "#{self.class}: unknown variant :#{variant}. Valid: #{VARIANTS.join(', ')}"
      end
      unless LABEL_POSITIONS.include?(label_position)
        raise ArgumentError, "#{self.class}: unknown label_position :#{label_position}. Valid: #{LABEL_POSITIONS.join(', ')}"
      end

      @current_page = current_page.to_i
      @total_pages = total_pages.to_i
      @page_url = page_url
      @series = series
      @variant = variant
      @label = label
      @label_position = label_position
      @rows_per_page = rows_per_page
      @rows_per_page_options = rows_per_page_options
      @rows_per_page_url = rows_per_page_url
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :current_page, :total_pages, :html_attrs

    def variant
      @variant
    end

    def simple?
      @variant == :simple
    end

    def numeric?
      @variant == :numeric || @variant == :numeric_loose
    end

    def loose?
      @variant == :numeric_loose
    end

    def label_position
      @label_position
    end

    def label_hidden?
      @label_position == :hidden
    end

    def label_text
      @label || "Page #{current_page} of #{total_pages}"
    end

    def has_rows_per_page?
      !@rows_per_page.nil?
    end

    attr_reader :rows_per_page, :rows_per_page_options, :rows_per_page_url

    # Normalizes the series into an array of page numbers and :gap symbols.
    # Accepts pagy's format (strings + :gap) or a plain array.
    def normalized_series
      (@series || default_series).map do |entry|
        case entry
        when :gap, "gap" then :gap
        when Integer then entry
        when String then entry.match?(/\A\d+\z/) ? entry.to_i : :gap
        else :gap
        end
      end
    end

    def previous_page
      current_page > 1 ? current_page - 1 : nil
    end

    def next_page
      current_page < total_pages ? current_page + 1 : nil
    end

    def previous_url
      previous_page && @page_url.call(previous_page)
    end

    def next_url
      next_page && @page_url.call(next_page)
    end

    def page_url_for(page)
      @page_url.call(page)
    end

    def current?(page)
      page.to_i == current_page
    end

    def wrapper_classes
      classes("font-sans flex items-center gap-4 text-sm text-text-primary", consumer: @class)
    end

    # Classes for a single button (page number or arrow) inside the pagination.
    # loose variant: each button has its own border and rounding.
    # numeric variant: buttons share a rounded pill container; individual
    # buttons get no border (container provides it) but use dividers.
    def button_classes(current: false, disabled: false)
      base = "inline-flex items-center justify-center h-8 min-w-8 px-2 text-sm leading-5 transition-colors"

      if loose? || simple?
        state = if disabled
          "border border-border-primary rounded-md text-text-disabled cursor-not-allowed"
        elsif current
          "border border-border-primary rounded-md bg-background-secondary text-text-primary font-medium"
        else
          "border border-border-primary rounded-md text-text-primary hover:bg-background-secondary focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-interactive-primary-default"
        end
      else
        # Joined-pill variant — inner buttons have divider borders only
        state = if disabled
          "border-r border-border-primary text-text-disabled cursor-not-allowed"
        elsif current
          "border-r border-border-primary bg-background-secondary text-text-primary font-medium"
        else
          "border-r border-border-primary text-text-primary hover:bg-background-secondary focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-interactive-primary-default focus-visible:ring-inset"
        end
      end

      "#{base} #{state}"
    end

    # Outer pill container for numeric variant (when not loose).
    def pill_classes
      if numeric? && !loose?
        "inline-flex items-stretch rounded-md border border-border-primary overflow-hidden divide-y-0 [&>*:last-child]:border-r-0"
      else
        "inline-flex items-center gap-1"
      end
    end

    def gap_classes
      if loose? || simple?
        "inline-flex items-center justify-center h-8 min-w-8 px-2 text-text-disabled"
      else
        "inline-flex items-center justify-center h-8 min-w-8 px-2 text-text-disabled border-r border-border-primary"
      end
    end

    def simple_layout_classes
      case label_position
      when :left   then "w-full flex items-center justify-between gap-4"
      when :right  then "w-full flex items-center justify-between gap-4 flex-row-reverse"
      when :center then "w-full flex flex-col items-center gap-1"
      when :hidden then "inline-flex items-center gap-2"
      end
    end

    def rows_per_page_select_id
      "shipwright-pagination-rpp-#{object_id}"
    end

    def render_prev_button
      render_arrow_button(url: previous_url, disabled: previous_page.nil?, icon: :"arrow-left", label: "Previous page")
    end

    def render_next_button
      render_arrow_button(url: next_url, disabled: next_page.nil?, icon: :"arrow-right", label: "Next page")
    end

    def render_arrow_button(url:, disabled:, icon:, label:)
      icon_tag = Shipwright::IconComponent.new(name: icon, size: :sm).render_in(self)
      if disabled
        content_tag(:span, icon_tag, class: button_classes(disabled: true), "aria-label": label, "aria-disabled": "true")
      else
        link_to(icon_tag, url, class: button_classes, "aria-label": label)
      end
    end

    def render_rows_per_page_select
      options_html = rows_per_page_options.map { |n|
        selected = (n.to_i == rows_per_page.to_i) ? ' selected="selected"' : ""
        url_attr = rows_per_page_url ? %( data-url="#{rows_per_page_url.call(n)}") : ""
        %(<option value="#{n}"#{selected}#{url_attr}>#{n}</option>)
      }.join

      %(<select id="#{rows_per_page_select_id}" class="#{rows_per_page_select_classes}" data-pagination-rows-per-page>#{options_html}</select>).html_safe
    end

    def rows_per_page_select_classes
      "rounded-md border border-border-primary bg-background-primary px-2 py-1 text-sm leading-5 text-text-primary focus:outline-none focus:ring-2 focus:ring-interactive-primary-default"
    end

    private

    # Auto-generated series when the consumer doesn't pass one.
    # Always includes first + last page and a WINDOW around current page.
    # Inserts :gap between non-contiguous ranges.
    def default_series
      return (1..total_pages).to_a if total_pages <= 7

      pages = [1, total_pages]
      ((current_page - WINDOW)..(current_page + WINDOW)).each do |p|
        pages << p if p.between?(1, total_pages)
      end
      pages = pages.uniq.sort

      with_gaps = []
      pages.each_with_index do |p, i|
        with_gaps << p
        next_p = pages[i + 1]
        with_gaps << :gap if next_p && next_p - p > 1
      end
      with_gaps
    end
  end
end

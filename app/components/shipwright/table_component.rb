module Shipwright
  # Data table — columns + rows + cells, composed via slots. Each cell
  # accepts an arbitrary ERB block so the consumer renders anything
  # (plain text, Avatar, Badge, progress bar, icon group, etc.). Matches
  # Shipwright Pro's Table organism.
  #
  # Usage:
  #   <%= render Shipwright::TableComponent.new(selectable: true, striped: true) do |table| %>
  #     <% table.with_column(label: "Name", sortable: true) %>
  #     <% table.with_column(label: "Role") %>
  #     <% table.with_column(label: "Status") %>
  #
  #     <% users.each do |user| %>
  #       <% table.with_row do |row| %>
  #         <% row.with_cell { user.name } %>
  #         <% row.with_cell { user.role } %>
  #         <% row.with_cell { render Shipwright::BadgeComponent.new(text: user.status) } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  # Options:
  #   selectable: true    — prepend a checkbox column (header + per-row)
  #   striped:    true    — alternate row backgrounds
  #   density:    :comfortable | :compact
  #
  # Sort indicator: pass `sortable: true` on a column to render the up/down
  # chevron icon. The component does NOT implement sorting behavior — clicks
  # are just a `<button>` emitting `turbo:click` / normal events so the
  # consumer handles sort via Turbo Stream, Stimulus, or a server round-trip.
  class TableComponent < BaseComponent
    DENSITIES = {
      comfortable: { cell_padding: "px-4 py-3" },
      compact:     { cell_padding: "px-3 py-2" }
    }.freeze

    # Column definition — a lightweight slot that stores label + flags.
    class Column < ViewComponent::Base
      attr_reader :label, :sortable, :align, :width

      def initialize(label:, sortable: false, align: :start, width: nil, sort_key: nil, sort_direction: nil)
        @label = label
        @sortable = sortable
        @align = align
        @width = width
        @sort_key = sort_key
        @sort_direction = sort_direction
      end

      attr_reader :sort_key, :sort_direction

      def call
        ""
      end
    end

    # Row slot holder — carries :selected and the pre-rendered cells
    # produced by RowBuilder. The parent template iterates `cells` and
    # emits <td> wrappers with the right padding/alignment classes.
    class Row < ViewComponent::Base
      attr_reader :selected, :id, :html_attrs, :cells

      def initialize(selected: false, id: nil, cells: [], **html_attrs)
        @selected = selected
        @id = id
        @cells = cells
        @html_attrs = html_attrs
      end

      def call
        ""
      end
    end

    # Per-cell data captured at slot-creation time. Nested slots can't easily
    # reach the parent's view_context from inside a lambda, so the Table's
    # `renders_many :rows` lambda runs each row's block against a RowBuilder,
    # which pre-captures every cell's content into a SafeBuffer.
    Cell = Struct.new(:rendered, :align, :html_attrs, keyword_init: true) do
      def align_classes
        case align
        when :center then "text-center"
        when :end, :right then "text-right"
        else "text-left"
        end
      end
    end

    # Exposed to the consumer inside `with_row do |row| … end`.
    class RowBuilder
      attr_reader :cells

      def initialize(view_context:)
        @view_context = view_context
        @cells = []
      end

      def with_cell(align: :start, **html_attrs, &block)
        content = block ? @view_context.capture(&block) : ""
        @cells << Cell.new(rendered: content, align: align, html_attrs: html_attrs)
      end
    end

    renders_many :columns, Column

    # Cells are captured into SafeBuffer strings inside this lambda (where
    # view_context is available) rather than inside Row's nested slot —
    # nested-slot lambdas run before their component is rendered, so they
    # have no view_context to call `capture` on.
    renders_many :rows, ->(selected: false, id: nil, **html_attrs, &block) {
      builder = RowBuilder.new(view_context: view_context)
      block&.call(builder)
      Row.new(
        selected: selected, id: id,
        cells: builder.cells,
        **html_attrs
      )
    }

    def initialize(
      selectable: false,
      striped: false,
      density: :comfortable,
      id: nil,
      class: nil,
      **html_attrs
    )
      unless DENSITIES.key?(density)
        raise ArgumentError, "#{self.class}: unknown density :#{density}. Valid: #{DENSITIES.keys.join(', ')}"
      end

      @selectable = selectable
      @striped = striped
      @density = density
      @id = id
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :id, :html_attrs

    def selectable?
      @selectable
    end

    def striped?
      @striped
    end

    def cell_padding
      DENSITIES.fetch(@density)[:cell_padding]
    end

    def wrapper_classes
      classes("font-sans w-full overflow-x-auto", consumer: @class)
    end

    def table_classes
      "w-full border-collapse text-sm text-text-primary"
    end

    def header_row_classes
      "border-b border-border-primary"
    end

    def header_cell_classes(column)
      alignment = case column.align
      when :center then "text-center"
      when :end, :right then "text-right"
      else "text-left"
      end
      "#{cell_padding} #{alignment} font-medium text-text-primary align-middle whitespace-nowrap"
    end

    def body_row_classes(row_index, row)
      base = "border-b border-border-primary last:border-b-0"
      stripe = striped? && row_index.odd? ? " bg-background-secondary" : ""
      selected = row.selected ? " bg-interactive-primary-default/5" : ""
      "#{base}#{stripe}#{selected}"
    end

    def body_cell_classes
      "#{cell_padding} align-middle text-text-primary"
    end

    # Picks a Feather icon for a sortable column's current state.
    #   sort_direction :asc  → chevron-up
    #   sort_direction :desc → chevron-down
    #   otherwise            → chevrons-up-down (neutral indicator)
    def sort_icon_for(column)
      case column.sort_direction&.to_sym
      when :asc  then :"chevron-up"
      when :desc then :"chevron-down"
      else :"chevrons-up-down"
      end
    end
  end
end

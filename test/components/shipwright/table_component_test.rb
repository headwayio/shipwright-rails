require "test_helper"

class Shipwright::TableComponentTest < ViewComponent::TestCase
  def test_renders_columns_in_header
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name")
      t.with_column(label: "Role")
    end

    assert_selector "thead th", count: 2
    assert_text "Name"
    assert_text "Role"
  end

  def test_renders_rows_and_cells
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name")
      t.with_row do |r|
        r.with_cell { "Alice" }
      end
      t.with_row do |r|
        r.with_cell { "Bob" }
      end
    end

    assert_selector "tbody tr", count: 2
    assert_selector "tbody td", count: 2
    assert_text "Alice"
    assert_text "Bob"
  end

  def test_sortable_column_shows_button_and_chevron
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name", sortable: true)
    end

    assert_selector "th button[data-table-sort]"
    assert_selector "th svg" # chevron icon
  end

  def test_non_sortable_column_shows_span_not_button
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name")
    end

    assert_no_selector "th button"
    assert_selector "th span", text: "Name"
  end

  def test_sortable_direction_asc_uses_up_chevron
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name", sortable: true, sort_direction: :asc)
    end

    # chevron-up polyline points
    assert_includes rendered_content, "18 15 12 9 6 15"
  end

  def test_sortable_direction_desc_uses_down_chevron
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name", sortable: true, sort_direction: :desc)
    end

    # chevron-down polyline points
    assert_includes rendered_content, "6 9 12 15 18 9"
  end

  def test_selectable_adds_checkbox_column
    render_inline(Shipwright::TableComponent.new(selectable: true)) do |t|
      t.with_column(label: "Name")
      t.with_row do |r|
        r.with_cell { "Alice" }
      end
    end

    # One in header + one per row = 2 checkboxes
    assert_selector "input[type='checkbox']", count: 2, visible: :all
  end

  def test_not_selectable_has_no_extra_checkbox_column
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name")
      t.with_row do |r|
        r.with_cell { "Alice" }
      end
    end

    assert_no_selector "input[type='checkbox']", visible: :all
  end

  def test_striped_variant_applies_zebra_classes
    render_inline(Shipwright::TableComponent.new(striped: true)) do |t|
      t.with_column(label: "Name")
      3.times do |i|
        t.with_row do |r|
          r.with_cell { "Row #{i}" }
        end
      end
    end

    assert_includes rendered_content, "bg-background-secondary"
  end

  def test_compact_density_uses_tighter_padding
    render_inline(Shipwright::TableComponent.new(density: :compact)) do |t|
      t.with_column(label: "Name")
      t.with_row { |r| r.with_cell { "x" } }
    end

    assert_includes rendered_content, "py-2"
  end

  def test_cell_block_renders_html_safe_content
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Person")
      t.with_row do |r|
        r.with_cell { '<span data-custom="true">rich</span>'.html_safe }
      end
    end

    assert_selector "tbody td [data-custom='true']", text: "rich"
  end

  def test_selected_row_marks_with_data_attribute
    render_inline(Shipwright::TableComponent.new(selectable: true)) do |t|
      t.with_column(label: "Name")
      t.with_row(selected: true) { |r| r.with_cell { "Alice" } }
    end

    assert_selector "tr[data-table-row-selected='true']"
  end

  def test_raises_on_invalid_density
    assert_raises(ArgumentError) do
      Shipwright::TableComponent.new(density: :huge)
    end
  end

  def test_column_width_applied_as_inline_style
    render_inline(Shipwright::TableComponent.new) do |t|
      t.with_column(label: "Name", width: "200px")
    end

    assert_selector "th[style*='200px']"
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::TableComponent.new(class: "my-8")) do |t|
      t.with_column(label: "x")
    end

    assert_selector "div.my-8"
  end
end

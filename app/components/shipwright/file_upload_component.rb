module Shipwright
  # File upload input — two layouts matching Shipwright Pro's FileUpload atom:
  #
  #   :inline    — A "Choose file" button + filename display on one line.
  #                Single or multiple files. Staged files listed below with
  #                remove (✕) buttons.
  #
  #   :dropzone  — A large dashed-border drop target with upload icon,
  #                helper text, accepted types, and a "Browse files" button.
  #                Supports click-to-browse and drag-and-drop. Staged files
  #                listed below with remove (✕) buttons.
  #
  # The real form control is a hidden `<input type="file" name="...">` so
  # server-side handling is plain Rails (`params[:name]` or `params[:name][]`
  # when `multiple: true`).
  #
  # Client-side validations (file type via `accept:`, per-file size via
  # `max_size:`) run in a tiny inline script installed once per page; they
  # surface a `data-file-upload-error` attribute and user-visible message.
  # Server-side validation is still your job.
  #
  # Usage:
  #   <%= render Shipwright::FileUploadComponent.new(
  #     name: "document", label: "Upload file", caption: "PDFs only"
  #   ) %>
  #
  #   <%= render Shipwright::FileUploadComponent.new(
  #     name: "documents[]", label: "Attachments",
  #     variant: :dropzone, multiple: true,
  #     accept: ".pdf,.doc,.jpg,.png", max_size: 10 * 1024 * 1024,
  #     caption: "Accepted file types: JPEG, Doc, PDF, PNG"
  #   ) %>
  class FileUploadComponent < BaseComponent
    VARIANTS = %i[inline dropzone].freeze
    BUTTON_POSITIONS = %i[left right].freeze
    BUTTON_VARIANTS = %i[primary secondary on_primary].freeze

    def initialize(
      name:,
      label: nil,
      caption: nil,
      variant: :inline,
      button_position: :right,
      button_variant: :primary,
      multiple: false,
      accept: nil,
      max_size: nil,
      disabled: false,
      error: nil,
      id: nil,
      class: nil,
      **html_attrs
    )
      unless VARIANTS.include?(variant)
        raise ArgumentError, "#{self.class}: unknown variant :#{variant}. Valid: #{VARIANTS.join(', ')}"
      end
      unless BUTTON_POSITIONS.include?(button_position)
        raise ArgumentError, "#{self.class}: unknown button_position :#{button_position}. Valid: #{BUTTON_POSITIONS.join(', ')}"
      end
      unless BUTTON_VARIANTS.include?(button_variant)
        raise ArgumentError, "#{self.class}: unknown button_variant :#{button_variant}. Valid: #{BUTTON_VARIANTS.join(', ')}"
      end

      @name = name
      @label_text = label
      @caption = caption
      @variant = variant
      @button_position = button_position
      @button_variant = button_variant
      @multiple = multiple
      @accept = accept
      @max_size = max_size
      @disabled = disabled
      @error = error
      @id = id || "shipwright-file-upload-#{name.to_s.gsub(/[^a-z0-9]/i, '_')}"
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :name, :label_text, :caption, :variant, :button_position,
      :accept, :max_size, :error, :id, :html_attrs

    def multiple?
      @multiple
    end

    def disabled?
      @disabled
    end

    def error?
      !@error.nil? && !@error.to_s.strip.empty?
    end

    def dropzone?
      @variant == :dropzone
    end

    def inline?
      @variant == :inline
    end

    def button_left?
      @button_position == :left
    end

    def wrapper_classes
      classes("font-sans flex flex-col gap-1", consumer: @class)
    end

    def field_row_classes
      base = "flex items-center rounded-md border overflow-hidden"
      state = if disabled?
        "border-border-primary bg-interactive-disable"
      elsif error?
        "border-utility-negative-default bg-background-primary"
      else
        "border-border-primary bg-background-primary"
      end
      "#{base} #{state}"
    end

    def filename_display_classes
      base = "flex-1 min-w-0 px-3 py-2 text-sm leading-5 truncate"
      if disabled?
        "#{base} text-text-disabled"
      elsif error?
        "#{base} text-utility-negative-default"
      else
        "#{base} text-text-primary"
      end
    end

    def button_classes
      base = "shrink-0 inline-flex items-center justify-center px-4 py-2 text-sm font-medium leading-5 cursor-pointer transition-colors " \
             "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-1 focus-visible:ring-offset-background-primary"
      state = case @button_variant
      when :primary
        "bg-interactive-primary-default text-interactive-on-primary hover:bg-interactive-primary-hover focus-visible:ring-interactive-primary-default"
      when :secondary
        "bg-interactive-secondary-default text-text-primary hover:opacity-90 focus-visible:ring-interactive-primary-default"
      when :on_primary
        "bg-interactive-primary-pressed text-interactive-on-primary hover:opacity-90 focus-visible:ring-interactive-on-primary"
      end
      disable = disabled? ? " opacity-50 cursor-not-allowed pointer-events-none" : ""
      "#{base} #{state}#{disable}"
    end

    def dropzone_classes
      base = "flex flex-col items-center justify-center gap-2 px-8 py-16 rounded-md border-2 border-dashed text-center transition-colors"
      state = if disabled?
        "border-border-primary bg-interactive-disable text-text-disabled cursor-not-allowed"
      elsif error?
        "border-utility-negative-default bg-background-primary text-text-primary"
      else
        "border-border-primary bg-background-primary text-text-primary hover:border-interactive-primary-default"
      end
      "#{base} #{state}"
    end

    def caption_classes
      base = "text-xs leading-4"
      error? ? "#{base} text-utility-negative-default" : "#{base} text-text-disabled"
    end

    def placeholder_text
      "No file selected"
    end

    def max_size_attr
      @max_size
    end

    def label_for
      "#{id}-input"
    end
  end
end

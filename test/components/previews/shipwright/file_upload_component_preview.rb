module Shipwright
  class FileUploadComponentPreview < Lookbook::Preview
    # @label Default (inline, button right)
    def default
      render(Shipwright::FileUploadComponent.new(name: "doc", label: "Upload file", caption: "Caption"))
    end

    # @label Inline — button on left
    def inline_button_left
      render(Shipwright::FileUploadComponent.new(name: "doc", label: "Upload file", button_position: :left, caption: "Caption"))
    end

    # @label Inline — on-primary button style
    def inline_on_primary
      render(Shipwright::FileUploadComponent.new(name: "doc", label: "Upload file", button_variant: :on_primary, caption: "Caption"))
    end

    # @label Inline — disabled
    def inline_disabled
      render(Shipwright::FileUploadComponent.new(name: "doc", label: "Upload file", disabled: true, caption: "Caption"))
    end

    # @label Inline — error state
    def inline_error
      render(Shipwright::FileUploadComponent.new(name: "doc", label: "Upload file", error: "File type not accepted"))
    end

    # @label Inline — multiple files
    def inline_multiple
      render(Shipwright::FileUploadComponent.new(name: "docs[]", label: "Attachments", multiple: true, caption: "Select multiple files"))
    end

    # @label Dropzone
    def dropzone
      render(Shipwright::FileUploadComponent.new(
        name: "docs[]",
        variant: :dropzone,
        multiple: true,
        accept: ".pdf,.doc,.jpg,.png",
        max_size: 10 * 1024 * 1024,
        caption: "Accepted file types: JPEG, Doc, PDF, PNG"
      ))
    end

    # @label Dropzone — disabled
    def dropzone_disabled
      render(Shipwright::FileUploadComponent.new(
        name: "docs[]",
        variant: :dropzone,
        multiple: true,
        disabled: true,
        caption: "Uploads are paused"
      ))
    end

    # @label Dropzone — error state
    def dropzone_error
      render(Shipwright::FileUploadComponent.new(
        name: "docs[]",
        variant: :dropzone,
        multiple: true,
        error: "One or more files exceed the max size (10 MB)"
      ))
    end

    # @label Grid
    def grid
      render_with_template
    end
  end
end

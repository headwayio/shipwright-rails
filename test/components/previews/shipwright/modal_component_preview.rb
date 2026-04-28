module Shipwright
  class ModalComponentPreview < Lookbook::Preview
    # @label Default (md)
    def default
      render_with_template
    end

    # @label Small
    def small
      render_with_template
    end

    # @label Large
    def large
      render_with_template
    end

    # @label XL
    def xl
      render_with_template
    end

    # @label No close button
    def no_close
      render_with_template
    end

    # @label Always open (inline)
    def always_open
      render_with_template
    end

    # @label Confirm-style (destructive action)
    def confirm
      render_with_template
    end
  end
end

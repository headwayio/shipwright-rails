module Shipwright
  class AccordionComponentPreview < Lookbook::Preview
    # @label Default (closed)
    def default
      render(Shipwright::AccordionComponent.new(title: "Accordion title")) do
        "Lorem ipsum dolor sit amet consectetur. Eget aenean eu in mattis ultrices tellus arcu. " \
        "Sed et turpis volutpat tristique risus. Elementum id interdum tortor faucibus ut."
      end
    end

    # @label Initially open
    def initially_open
      render(Shipwright::AccordionComponent.new(title: "Accordion title", open: true)) do
        "Starts expanded. Great for the first item in an FAQ."
      end
    end

    # @label Stacked group
    def stacked_group
      render_with_template
    end

    # @label Long body
    def long_body
      render_with_template
    end
  end
end

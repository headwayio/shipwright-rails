module Shipwright
  class Engine < ::Rails::Engine
    isolate_namespace Shipwright

    # ViewComponent auto-discovers components under app/components/
    # This is handled by view_component's default configuration.

    # Expose Shipwright view helpers (e.g. shipwright_flash_toasts) to the
    # host application's views.
    initializer "shipwright.view_helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper Shipwright::FlashHelper
      end
    end

    initializer "shipwright.lookbook" do
      if defined?(Lookbook)
        config.lookbook.preview_paths << root.join("test/components/previews")
      end
    end
  end
end

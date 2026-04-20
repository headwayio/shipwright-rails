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

    # Register Shipwright's Lookbook preview path. Must run BEFORE Lookbook's
    # own `lookbook.set_autoload_paths` initializer, otherwise the preview
    # classes never make it onto Rails' autoload paths and Lookbook's
    # `code_object.path.constantize` call silently NameErrors (swallowed by
    # its `rescue => e; logger.error; nil`) — the previews appear in the
    # file tree but don't render.
    #
    # We also push the path onto `config.autoload_paths` directly as a
    # belt-and-suspenders: ensures Zeitwerk can resolve the preview class
    # constants even if Lookbook's ordering changes in a future release.
    initializer "shipwright.lookbook", before: "lookbook.set_autoload_paths" do |app|
      if defined?(Lookbook)
        preview_path = root.join("test/components/previews").to_s
        config.lookbook.preview_paths << preview_path
        app.config.autoload_paths << preview_path unless app.config.autoload_paths.include?(preview_path)
      end
    end
  end
end

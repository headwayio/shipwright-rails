module Shipwright
  class Engine < ::Rails::Engine
    isolate_namespace Shipwright

    # ViewComponent auto-discovers components under app/components/
    # This is handled by view_component's default configuration.

    initializer "shipwright.lookbook" do
      if defined?(Lookbook)
        config.lookbook.preview_paths << root.join("test/components/previews")
      end
    end
  end
end

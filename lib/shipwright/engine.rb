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

    # Register Shipwright's Lookbook + ViewComponent preview path across all
    # the places a host app's Rails stack needs to know about it:
    #
    #   1. `config.lookbook.preview_paths` — Lookbook's preview discovery.
    #   2. `config.view_component.previews.paths` — ViewComponent's preview
    #      controller, used by `render_with_template` to locate the sibling
    #      `<preview_class>/<method>.html.erb` templates. Without this,
    #      consumers hit `ActionView::MissingTemplate` on any preview
    #      method that calls `render_with_template`.
    #   3. `app.config.autoload_paths` — so `constantize` on the preview
    #      class name resolves. Lookbook silently swallows NameError from
    #      constantize, which makes the failure mode invisible in the UI
    #      (previews appear in the tree but render blank).
    #
    # Runs BEFORE Lookbook's `lookbook.set_autoload_paths` initializer so
    # all three registrations land before Lookbook/ViewComponent snapshot
    # their configuration.
    initializer "shipwright.lookbook", before: "lookbook.set_autoload_paths" do |app|
      preview_path = root.join("test/components/previews").to_s

      if app.config.respond_to?(:view_component) && app.config.view_component.respond_to?(:previews)
        begin
          app.config.view_component.previews.paths << preview_path
        rescue FrozenError
          # Tests boot the engine without a full Rails app; view_component's
          # previews.paths starts as a frozen []. Safe to skip — the test
          # harness doesn't exercise preview rendering.
        end
      end

      if defined?(Lookbook)
        config.lookbook.preview_paths << preview_path
      end

      unless app.config.autoload_paths.include?(preview_path)
        begin
          app.config.autoload_paths << preview_path
        rescue FrozenError
          # autoload_paths already snapshotted by Zeitwerk — skip. Previews
          # still resolve via view_component's / Lookbook's own registration.
        end
      end
    end
  end
end

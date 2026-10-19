# tailwindcss-rails generates app/assets/builds/tailwind/shipwright.css with an
# ABSOLUTE path into wherever the engine is installed, so it cannot be committed
# — it would be wrong on CI and on every other contributor's checkout, and the
# Tailwind build would silently drop the engine's theme and utilities.
#
# Regenerate it before every build instead, so the path is always right for the
# current environment. assets:precompile depends on tailwindcss:build, so this
# covers that path too.
if Rake::Task.task_defined?("tailwindcss:build")
  Rake::Task["tailwindcss:build"].enhance([ "tailwindcss:engines" ])
end

# Shipwright

Headway's design system as Rails ViewComponents with Tailwind 4 theme tokens.

## Installation

Add to your Gemfile:

```ruby
gem "shipwright", github: "headwayio/shipwright-rails", tag: "v0.1.0"
```

Run `bundle install`.

## Setup

### Tailwind CSS

Add the Shipwright engine import to your Tailwind input file:

```css
/* app/assets/tailwind/application.css */
@import "tailwindcss";
@import "../builds/tailwind/shipwright.css";
```

The `tailwindcss:engines` rake task runs automatically before Tailwind builds and generates the `shipwright.css` stub. No manual path configuration needed.

### Layout

Use an explicit stylesheet tag in your layout — **not** `stylesheet_link_tag :app`:

```erb
<%= stylesheet_link_tag "tailwind", "data-turbo-track": "reload" %>
```

## Usage

```erb
<%= render Shipwright::ButtonComponent.new(variant: :primary, size: :md) { "Click me" } %>
```

### ButtonComponent

| Param | Values | Default |
|-------|--------|---------|
| `variant` | `:primary`, `:secondary`, `:outline` | `:primary` |
| `size` | `:sm`, `:md`, `:lg` | `:md` |
| `class` | Any Tailwind classes | `nil` |

Additional HTML attributes (`id`, `data-*`, etc.) are passed through.

### Toasts

Render the container once in your layout and hand it the flash:

```erb
<%= render Shipwright::ToastContainerComponent.new(flash: flash) %>
```

The container is `position: fixed`, and toasts must be its **children**. This
looks equivalent and is not — the toasts render outside the container, at
normal body flow position, usually below the fold:

```erb
<%# Wrong: the toasts are siblings of the container, not inside it %>
<%= render Shipwright::ToastContainerComponent.new %>
<%= shipwright_flash_toasts %>
```

If you want to pass options to the helper, use a block:

```erb
<%= render Shipwright::ToastContainerComponent.new(position: :bottom_right) do %>
  <%= shipwright_flash_toasts(duration: 8000) %>
<% end %>
```

Flash keys map to variants: `notice`/`success` → success, `alert`/`error` →
error, `warning` → warning, `info` → info. Anything else is ignored, so
`flash[:form_id]` and friends don't become toasts. Pass `mapping:` to change
that.

To raise a toast from a controller action with Turbo, append to the container
by its DOM id:

```ruby
render turbo_stream: turbo_stream.append(
  Shipwright::ToastContainerComponent::DOM_ID,
  Shipwright::ToastComponent.new(body: "Saved", variant: :success)
)
```

`ToastComponent` takes `title:` (a one-line heading, truncated) and `body:`
(wraps). Either may be omitted, but not both. Flash messages go to `body:`,
since a flash is one string and may be long.

### Class overrides

All components accept a `class:` keyword. Consumer classes are merged with component defaults using `tailwind_merge` — conflicting utilities are resolved intelligently:

```erb
<%= render Shipwright::ButtonComponent.new(class: "w-full bg-red-500") { "Custom" } %>
<%# bg-red-500 replaces bg-primary; w-full is added %>
```

### Composing with slots

Components use ViewComponent slots for composition:

```erb
<%= render Shipwright::CardComponent.new do |card| %>
  <% card.with_header { "Title" } %>
  <% card.with_body { "Content" } %>
  <% card.with_footer do %>
    <%= render Shipwright::ButtonComponent.new(variant: :primary) { "Save" } %>
  <% end %>
<% end %>
```

## Theming

Shipwright defines design tokens via Tailwind 4's `@theme`. Override them in your app's Tailwind CSS:

```css
/* Use plain @theme {} — no modifiers like `default` or `inline` */
@theme {
  --color-primary: oklch(0.55 0.25 150);
  --color-secondary: oklch(0.6 0.2 30);
}
```

### Available tokens

| Token | Default |
|-------|---------|
| `--color-primary` | `oklch(0.6 0.2 260)` |
| `--color-secondary` | `oklch(0.65 0.15 330)` |
| `--color-surface` | `oklch(0.98 0 0)` |
| `--color-on-surface` | `oklch(0.2 0 0)` |
| `--color-muted` | `oklch(0.55 0.02 260)` |
| `--color-destructive` | `oklch(0.55 0.25 30)` |
| `--font-sans` | `"Inter", ui-sans-serif, system-ui, sans-serif` |
| `--radius-sm` | `0.25rem` |
| `--radius-default` | `0.5rem` |
| `--radius-lg` | `0.75rem` |
| `--radius-full` | `9999px` |

Token defaults are brand-agnostic placeholders. Override at minimum the color tokens for your project.

Font loading is the consuming app's responsibility — Shipwright defines `--font-sans` but does not bundle font files.

## Development

Run the dummy app for Lookbook previews:

```bash
cd test/dummy
bundle exec rake tailwindcss:build
bundle exec rails server -p 3030
```

Visit `http://localhost:3030/lookbook` for component previews, or `http://localhost:3030/components` for the showcase page.

### Tests

```bash
bundle exec rake test
```

### Creating new components

1. Create `app/components/shipwright/my_component.rb` inheriting from `Shipwright::BaseComponent`
2. Use `VARIANTS`/`SIZES` frozen hashes for option mappings
3. Accept `class:` via `binding.local_variable_get(:class)` and pass as `consumer:` to `classes`
4. Add tests in `test/components/shipwright/`
5. Add a Lookbook preview in `test/components/previews/shipwright/`
6. Rebuild Tailwind: `cd test/dummy && bundle exec rake tailwindcss:build`

## Dependencies

- Rails >= 8.1
- ViewComponent >= 3.0
- tailwindcss-rails >= 4.0
- tailwind_merge ~> 1.4

## License

MIT

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

### Content Security Policy

Several components (toast, modal, slideout, dropdown, file upload) bootstrap
themselves with a small inline `<script>`. If your app sets a nonce generator:

```ruby
config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
```

Shipwright reads it and emits `<script nonce="...">` automatically — no
configuration needed. Apps with no nonce generator get the same markup as
before, without the attribute.

If you render Shipwright components in a context with no request (a mailer, a
standalone `render`), the nonce is simply omitted.

## Usage

```erb
<%= render Shipwright::ButtonComponent.new(hierarchy: :primary, size: :md) { "Click me" } %>
```

### Components

`accordion` `avatar` `badge` `banner` `breadcrumb` `brand_icon` `button`
`checkbox` `dropdown` `file_upload` `icon` `input` `link` `logo` `modal`
`pagination` `radio` `radio_group` `slideout` `table` `toast`
`toast_container`

Every component's full parameter list is in its own file under
`app/components/shipwright/`. For a live preview of each one with its
variants, run the dummy app and open Lookbook:

```bash
cd test/dummy && bin/dev
# then http://localhost:3000/lookbook
```

See [Development](#development) for the first-run steps.

### ButtonComponent

| Param | Values | Default |
|-------|--------|---------|
| `hierarchy` | `:primary`, `:secondary`, `:tertiary`, `:destructive` | `:primary` |
| `size` | `:sm`, `:md`, `:lg` | `:md` |
| `shape` | `:rounded`, `:pill` | `:rounded` |
| `icon_only` | `true`, `false` | `false` |
| `disabled` | `true`, `false` | `false` |
| `class` | Any Tailwind classes | `nil` |

The parameter is `hierarchy:`, not `variant:`. An unknown hierarchy raises
`ArgumentError`; an unrecognised keyword is passed through as an HTML
attribute, so a typo renders a button with its default styling rather than
failing.

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
<%# bg-red-500 replaces bg-interactive-primary-default; w-full is added %>
```

### Composing with slots

Several components use ViewComponent slots. `ModalComponent` takes a block for
its body, `with_action` for each footer button, and `with_header` to replace
the default header entirely:

```erb
<%= render Shipwright::ModalComponent.new(id: "edit-profile",
                                          title: "Edit profile",
                                          subtitle: "Update your account info") do |m| %>
  <p class="text-sm">Modal body content.</p>

  <% m.with_action do %>
    <%= render Shipwright::ButtonComponent.new(
          hierarchy: :secondary,
          data: { shipwright_modal_close: "edit-profile" }) { "Cancel" } %>
  <% end %>
  <% m.with_action do %>
    <%= render Shipwright::ButtonComponent.new(hierarchy: :primary) { "Save" } %>
  <% end %>
<% end %>
```

`TableComponent`, `DropdownComponent`, `BreadcrumbComponent`,
`RadioGroupComponent`, `SlideoutComponent` and `BannerComponent` follow the
same pattern.

## Theming

Shipwright defines design tokens via Tailwind 4's `@theme`. Override them in your app's Tailwind CSS:

```css
/* Use plain @theme {} — no modifiers like `default` or `inline` */
@theme {
  --color-primary: oklch(0.55 0.25 150);
  --color-secondary: oklch(0.6 0.2 30);
}
```

### Theming a brand

Override tokens in a `@theme` block that comes **after** the Shipwright
import, so your values win:

```css
@import "../builds/tailwind/shipwright.css";

@theme {
  --color-interactive-primary-default: #e8c547;  /* a light primary */
  --color-interactive-on-primary:      #1c1c1c;  /* so its label must be dark */
}
```

That is usually the whole re-brand. Foregrounds are **one token per fill**,
because the readable label colour is a property of the background it sits on:

| Fill | Label token |
|------|-------------|
| `bg-interactive-primary-*` | `--color-interactive-on-primary` |
| `bg-utility-neutral-default` | `--color-utility-on-neutral` |
| `bg-utility-information-default` | `--color-utility-on-information` |
| `bg-utility-positive-default` | `--color-utility-on-positive` |
| `bg-utility-negative-default` | `--color-utility-on-negative` |
| `bg-utility-warning-default` | `--color-utility-on-warning` |

The utility fills are saturated colours that stay dark whatever your primary
is, so their labels are usually left alone — you change `on-primary` and
nothing else. They exist as separate tokens so that *if* you do restyle a
sentiment colour, you can fix its label without touching the others.

`--color-text-inverse` remains for genuine "text on an inverted background",
as opposed to "text on this particular fill".

### Available tokens

Defined in `app/assets/tailwind/shipwright/engine.css`, which is the theme the
components actually read.

| Token | Default |
|-------|---------|
| **Interactive colors (backgrounds, fills, interaction states)** | |
| `--color-interactive-primary-default` | `#14161c` |
| `--color-interactive-primary-hover` | `#595d6a` |
| `--color-interactive-primary-pressed` | `#333747` |
| `--color-interactive-secondary-default` | `#fdfdfd` |
| `--color-interactive-disable` | `#eaeaea` |
| **Border colors** | |
| `--color-border-interactive` | `#14161c` |
| `--color-border-inverse` | `#fdfdfd` |
| `--color-border-primary` | `#eaeaea` |
| **Utility colors (semantic sentiments)** | |
| `--color-utility-neutral-default` | `#292c39` |
| `--color-utility-information-default` | `#206ac7` |
| `--color-utility-positive-default` | `#48a356` |
| `--color-utility-negative-default` | `#b62e2e` |
| `--color-utility-warning-default` | `#c09c17` |
| **Foreground colors** | |
| `--color-interactive-on-primary` | `#fdfdfd` |
| `--color-utility-on-neutral` | `#fdfdfd` |
| `--color-utility-on-information` | `#fdfdfd` |
| `--color-utility-on-positive` | `#fdfdfd` |
| `--color-utility-on-negative` | `#fdfdfd` |
| `--color-utility-on-warning` | `#fdfdfd` |
| **Text colors** | |
| `--color-text-primary` | `#050507` |
| `--color-text-inverse` | `#fdfdfd` |
| `--color-text-disabled` | `#595d6a` |
| **Background colors** | |
| `--color-background-primary` | `#fdfdfd` |
| `--color-background-secondary` | `#f3f3f3` |
| **Typography** | |
| `--font-sans` | `"Manrope", ui-sans-serif, system-ui, sans-serif` |
| `--text-base` | `1rem` |
| `--leading-2xs` | `1.25rem` |
| `--tracking-base` | `0` |
| **Spacing (Shipwright Pro scale)** | |
| `--spacing-2xs` | `8px` |
| `--spacing-xs` | `12px` |
| `--spacing-sm` | `16px` |
| **Border radius (Shipwright Pro scale)** | |
| `--radius-md` | `6px` |

Token defaults come from Shipwright Pro. Override the colour tokens for your
brand in a `@theme` block that comes after the Shipwright import, so your
values win — see [Theming a brand](#theming-a-brand), which covers the
light-primary case that needs more than a one-token change.

Font loading is the consuming app's responsibility — Shipwright sets
`--font-sans` but does not bundle font files.

Note that `app/assets/tailwind/shipwright/tokens.css` also ships in the gem.
It is synced from `headwayio/shipwright-ui` and is **not** wired into anything
yet, and it uses different token names — don't theme against it. See
[#34](https://github.com/headwayio/shipwright-rails/issues/34).

## Development

Run the dummy app for Lookbook previews:

```bash
cd test/dummy
bundle exec rake tailwindcss:build
bin/dev                     # bin/rails server; add -p to change the port
```

Visit `http://localhost:3000/lookbook` for component previews, or
`http://localhost:3000/components` for the showcase page.

`bin/dev` uses a relative `./bin/rails`, so run it from `test/dummy` — it
won't work from the repo root, which has no `bin/dev` of its own.

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

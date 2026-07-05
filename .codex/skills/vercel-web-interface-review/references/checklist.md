# Vercel Web Interface Guidelines Checklist

Use this checklist when reviewing UI code. Report only issues visible in the code under review.

## Accessibility

- Icon-only buttons need `aria-label`.
- Form controls need `<label>` or `aria-label`.
- Interactive elements need keyboard handlers such as `onKeyDown` or `onKeyUp` when native semantics are absent.
- Use `<button>` for actions and `<a>` or `<Link>` for navigation. Flag clickable `<div>` or `<span>`.
- Images need `alt`, or `alt=""` if decorative.
- Decorative icons need `aria-hidden="true"`.
- Async updates such as toasts or validation need `aria-live="polite"`.
- Prefer semantic HTML before ARIA.
- Keep headings hierarchical from `<h1>` through `<h6>` and include a skip link for main content where relevant.
- Add `scroll-margin-top` on heading anchors.

## Focus States

- Interactive elements need a visible focus treatment such as `focus-visible:ring-*` or equivalent.
- Flag `outline-none` or `outline: none` without a visible replacement.
- Prefer `:focus-visible` over `:focus`.
- Use `:focus-within` for compound controls where group focus matters.

## Forms

- Inputs need meaningful `name` and `autocomplete`.
- Use the correct `type`, and `inputmode` where helpful.
- Never block paste with `onPaste` plus `preventDefault`.
- Labels must be clickable through `htmlFor` or wrapping.
- Disable spellcheck on emails, codes, and usernames.
- Checkboxes and radios should share one hit target with the label.
- Submit buttons should remain enabled until the request starts, then show a spinner during the request.
- Render errors inline next to fields and focus the first error on submit.
- Placeholders should end with `…` and show an example pattern.
- Use `autocomplete="off"` on non-auth fields to avoid password manager triggers when appropriate.
- Warn before navigation with unsaved changes.

## Animation

- Honor `prefers-reduced-motion`.
- Animate `transform` and `opacity` only.
- Flag `transition: all`.
- Set the correct `transform-origin`.
- For SVG motion, apply transforms on a `<g>` wrapper with `transform-box: fill-box` and `transform-origin: center`.
- Animations should be interruptible by user input.

## Typography

- Prefer `…` over `...`.
- Prefer curly quotes over straight quotes in copy.
- Use non-breaking spaces in cases like `10&nbsp;MB` or `⌘&nbsp;K`.
- Loading states should end with `…`.
- Use `font-variant-numeric: tabular-nums` for number columns and comparisons.
- Use `text-wrap: balance` or `text-pretty` on headings.

## Content Handling

- Text containers should handle long content with `truncate`, `line-clamp-*`, or `break-words`.
- Flex children that truncate text usually need `min-w-0`.
- Handle empty states instead of rendering broken UI for empty strings or arrays.
- Anticipate short, average, and very long user-generated content.

## Images

- `<img>` needs explicit `width` and `height`.
- Below-the-fold images should use `loading="lazy"`.
- Above-the-fold critical images should use `priority` or `fetchpriority="high"` where supported.

## Performance

- Large lists over roughly 50 items should be virtualized or use a similar strategy.
- Do not read layout in render with APIs such as `getBoundingClientRect`, `offsetHeight`, `offsetWidth`, or `scrollTop`.
- Batch DOM reads and writes instead of interleaving them.
- Prefer uncontrolled inputs; controlled inputs must stay cheap per keystroke.
- Add `<link rel="preconnect">` for CDN or asset domains where relevant.
- Preload critical fonts and use `font-display: swap`.

## Navigation & State

- Reflect state in the URL for filters, tabs, pagination, or expanded panels when the UI is stateful.
- Links should use `<a>` or `<Link>` for native browser behaviors.
- Deep-link stateful UI where it materially affects navigation or sharing.
- Destructive actions need confirmation or an undo window.

## Touch & Interaction

- Use `touch-action: manipulation` where tap latency matters.
- Set `-webkit-tap-highlight-color` intentionally.
- Use `overscroll-behavior: contain` in modals, drawers, and sheets.
- During drag, disable text selection and use `inert` where appropriate.
- Use `autoFocus` sparingly and avoid it on mobile.

## Safe Areas & Layout

- Full-bleed layouts need `env(safe-area-inset-*)` support where relevant.
- Avoid unwanted horizontal scrollbars.
- Prefer flex or grid over JS measurement for layout.

## Dark Mode & Theming

- Use `color-scheme: dark` on `<html>` for dark themes.
- Keep `<meta name="theme-color">` aligned with the page background.
- Native `<select>` needs explicit colors in dark mode, especially on Windows.

## Locale & i18n

- Format dates and times with `Intl.DateTimeFormat`.
- Format numbers and currency with `Intl.NumberFormat`.
- Detect language from `Accept-Language` or `navigator.languages`, not IP.

## Hydration Safety

- Inputs with `value` need `onChange`, or use `defaultValue` for uncontrolled inputs.
- Guard date and time rendering against server-client mismatches.
- Use `suppressHydrationWarning` only when truly necessary.

## Hover & Interactive States

- Buttons and links need `hover:` feedback.
- Hover, active, and focus states should increase contrast relative to the resting state.

## Content & Copy

- Prefer active voice.
- Use Title Case for headings and buttons.
- Use numerals for counts.
- Prefer specific button labels.
- Error messages should include the next step or fix.
- Address the user in second person.
- Prefer `&` over `and` where space is constrained.

## Anti-Patterns

Flag these immediately when present:

- `user-scalable=no` or `maximum-scale=1`
- `onPaste` with `preventDefault`
- `transition: all`
- `outline-none` without a visible focus-visible replacement
- Inline `onClick` navigation without `<a>`
- Click handlers on `<div>` or `<span>` where a button belongs
- Images without dimensions
- Large arrays rendered with `.map()` without virtualization
- Form inputs without labels
- Icon buttons without `aria-label`
- Hardcoded date or number formatting instead of `Intl.*`
- `autoFocus` without a clear justification

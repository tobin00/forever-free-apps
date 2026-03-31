# 02 - Design Language

> The visual identity shared across all apps. Anyone using one of our apps should recognize another instantly.

---

## Brand Identity

### Personality
- **Trustworthy** — clean, no tricks, no dark patterns
- **Friendly** — warm and approachable, not corporate
- **Focused** — does one thing well, no bloat
- **Crafted** — feels polished, not slapped together

### Tagline (for About pages)
> Free apps, no ads, no tracking. Just useful tools made with care.

---

## Color Palette

### Light Mode

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| **Primary** | Deep Ocean Blue | `#1B5E7B` | App bar, primary buttons, active nav items |
| **Primary Variant** | Dark Teal | `#134B63` | Pressed states, status bar |
| **Accent** | Warm Amber | `#F4A726` | FABs, highlights, progress indicators, call-to-action |
| **Accent Variant** | Deep Amber | `#D4911E` | Pressed states for accent elements |
| **Background** | Off-White | `#FAFBFC` | Screen backgrounds |
| **Surface** | White | `#FFFFFF` | Cards, bottom sheets, dialogs |
| **On Primary** | White | `#FFFFFF` | Text/icons on primary-colored backgrounds |
| **On Accent** | Dark Text | `#1A1A1A` | Text/icons on accent-colored backgrounds |
| **On Background** | Near Black | `#1A1A1A` | Primary text on light backgrounds |
| **On Background Secondary** | Gray | `#5F6368` | Secondary/caption text |
| **Divider** | Light Gray | `#E0E0E0` | Separators, borders |
| **Error** | Red | `#D32F2F` | Error states |
| **Success** | Green | `#2E7D32` | Success states, correct answers |

### Dark Mode

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| **Primary** | Light Teal | `#4DA8B5` | App bar text, primary buttons, active nav |
| **Primary Variant** | Mid Teal | `#3A8F9A` | Pressed states |
| **Accent** | Warm Amber | `#F4A726` | Same as light mode (good contrast on dark) |
| **Background** | Deep Navy | `#0F1419` | Screen backgrounds |
| **Surface** | Dark Card | `#1A2332` | Cards, bottom sheets |
| **On Background** | Off-White | `#E8EAED` | Primary text |
| **On Background Secondary** | Medium Gray | `#9AA0A6` | Secondary text |
| **Divider** | Dark Divider | `#2D3748` | Separators |

### Why These Colors
- **Deep Ocean Blue** conveys trust and reliability without being boring
- **Warm Amber** adds friendliness and energy; makes CTAs pop
- The combination is distinctive enough to be recognizable across apps
- Both colors have sufficient contrast ratios for accessibility (WCAG AA)

---

## Typography

### Font Families

| Role | Font | Weight | Fallback |
|------|------|--------|----------|
| **Display / Headers** | Nunito | Bold (700) | sans-serif |
| **Titles** | Sora | SemiBold (600) | sans-serif |
| **Body / UI** | Inter | Regular (400), Medium (500), SemiBold (600) | sans-serif |

### Why These Fonts
- **Nunito** has rounded terminals — feels warm and friendly, matches brand personality
- **Sora** is geometric and confident — works well for titles and app bar text
- **Inter** is designed specifically for screens — highly legible at all sizes
- All three are Google Fonts (free, no licensing issues)

### Type Scale

| Style | Font | Size | Weight | Line Height | Usage |
|-------|------|------|--------|-------------|-------|
| **Display Large** | Nunito | 32sp | Bold | 1.25 | Hero elements (quiz letter display) |
| **Display Medium** | Nunito | 28sp | Bold | 1.25 | Screen titles when prominent |
| **Headline** | Nunito | 22sp | Bold | 1.3 | Section headers |
| **Title Large** | Sora | 20sp | SemiBold | 1.3 | App bar titles |
| **Title Medium** | Inter | 16sp | SemiBold | 1.4 | Card titles, list headers |
| **Body Large** | Inter | 16sp | Regular | 1.5 | Primary reading text |
| **Body Medium** | Inter | 14sp | Regular | 1.5 | Default body text |
| **Body Small** | Inter | 12sp | Regular | 1.5 | Captions, helper text |
| **Label Large** | Inter | 14sp | SemiBold | 1.2 | Buttons, nav labels |
| **Label Medium** | Inter | 12sp | Medium | 1.2 | Chips, badges |

**Note:** All sizes use `sp` (scaled pixels) so they respect the user's system font size preference.

---

## Spacing & Layout

### Spacing Scale

Use multiples of 4dp for all spacing:

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4dp | Tight internal padding, icon-to-text gap |
| `sm` | 8dp | Between related elements |
| `md` | 16dp | Standard padding, between sections |
| `lg` | 24dp | Between major sections |
| `xl` | 32dp | Top/bottom screen padding |
| `xxl` | 48dp | Hero spacing, empty states |

### Screen Padding
- Horizontal screen padding: **16dp**
- Top padding below app bar: **16dp**
- Bottom padding above bottom nav: **16dp**

### Card Style
- Corner radius: **12dp**
- Elevation: **1dp** (light mode), **0dp with border** (dark mode)
- Internal padding: **16dp**

### Touch Targets
- Minimum touch target: **48x48dp** (accessibility requirement)
- Buttons: minimum height **48dp**, horizontal padding **24dp**

---

## Animation Principles

### Philosophy
- Animations serve a **purpose** (guide attention, show relationships, provide feedback)
- Never animate just for show
- Keep durations short — users should never wait for an animation to finish

### Standard Durations

| Type | Duration | Curve | Usage |
|------|----------|-------|-------|
| **Micro** | 100ms | `easeOut` | Button press feedback, color changes |
| **Short** | 200ms | `easeInOut` | Page element transitions, reveals |
| **Medium** | 300ms | `easeInOut` | Screen transitions, card expansions |
| **Stagger** | 50ms delay per item | `easeOut` | Sequential list item reveals |

### Specific Animations

**Quiz Reveal (Letter Quiz):**
- NATO word fades in + slides up 8dp over 200ms with `easeOut`

**Word Quiz Reveal (vertical letter list):**
- Each letter-row slides in from right + fades in
- 50ms stagger delay between each letter
- Duration per item: 250ms with `easeOut`
- Total for a 5-letter word: ~450ms (feels quick but readable)

**Page Transitions:**
- Use Flutter's default Material page transitions
- No custom transitions unless they serve a clear purpose

**Respect User Preferences:**
- Check `MediaQuery.of(context).disableAnimations`
- If true, skip all animations and show final state immediately

---

## Common Components

These components live in `shared_app_core` and are used by every app.

### App Shell
- Material 3 Scaffold
- Top app bar with app name and About (info) icon
- Bottom navigation bar for main sections
- Consistent padding and safe area handling

### Bottom Navigation Bar
- 3-4 items maximum
- Each item has an icon and a text label (no icon-only nav)
- Active item uses **Primary** color (light mode) or **Primary Light** (dark mode)
- Inactive items use **On Background Secondary** color
- Bar background: **Surface** color with subtle top border

### Primary Button
- Background: **Primary** color
- Text: **On Primary**, **Label Large** style
- Corner radius: **24dp** (pill shape)
- Height: **48dp** minimum
- Horizontal padding: **24dp**
- Pressed state: darken background 10%
- Full-width variant available

### Secondary Button
- Background: transparent
- Border: 1.5dp **Primary** color
- Text: **Primary** color, **Label Large** style
- Same dimensions as Primary Button

### About Page
- Shared component configured per-app
- Content:
  - App icon and name
  - App version (pulled from pubspec.yaml automatically)
  - Horizontal divider
  - Mission statement (2-3 paragraphs, same across all apps, configured in shared_app_core)
  - Donation button (Accent color, links to external URL)
  - "Made with care" footer
- The mission statement text:
  > This app is part of a collection of free, ad-free utilities. No ads. No tracking. No data collection. Just a useful tool, built with care.
  >
  > In the early days of the internet, people made software because they wanted to help others. We're bringing that spirit back — one app at a time.
  >
  > These apps will always be free. If you find them useful and want to help cover the cost of keeping them available, donations are welcome but never expected.

### Donation Widget
- Accent-colored outlined button: "Support These Apps"
- Opens external URL in system browser
- Appears on About page only (never intrusive)

---

## Iconography

- Use **Material Icons Outlined** as the default icon set
- Consistent icon size: **24dp** in app bars, **28dp** in bottom nav
- Icons should always be paired with text labels in navigation

---

## Dark Mode / Light Mode

- **Follow system setting by default** (no manual toggle needed for v1)
- Both modes must look intentional (not just an inverted light mode)
- Test every screen in both modes
- If a manual toggle is added later, use `shared_app_core` settings

---

## App Icon Template

Each app gets a unique icon but follows a consistent style:
- **Shape:** Rounded square (follows platform convention)
- **Background:** Gradient using Primary → Primary Variant
- **Foreground:** White icon/symbol representing the app's function
- **Style:** Simple, bold, recognizable at small sizes (16x16 still legible)

For NATO Alphabet app: A bold white "A" in Nunito Bold with a small "α" (alpha symbol) as a subtle detail, on the ocean blue gradient background.

---

## Instructions for AI

When implementing any app in this monorepo:
1. Always import `shared_app_core` — theme, About page, and common widgets come for free
2. Only create app-specific screens and logic; never duplicate shared components
3. Follow the spacing scale and type scale exactly as defined above
4. Verify every screen in both light and dark modes during self-testing
5. If a design need arises that isn't covered here, **update this document** with the new pattern rather than creating a one-off exception
6. When the user asks about colors, fonts, or visual style, reference this document

---
name: SilverGuard Design System
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1c1b1b'
  on-surface-variant: '#42474e'
  inverse-surface: '#313030'
  inverse-on-surface: '#f3f0ef'
  outline: '#72777e'
  outline-variant: '#c2c7ce'
  surface-tint: '#396285'
  primary: '#00263f'
  on-primary: '#ffffff'
  primary-container: '#0b3c5d'
  on-primary-container: '#7fa7cd'
  inverse-primary: '#a3cbf2'
  secondary: '#006e2e'
  on-secondary: '#ffffff'
  secondary-container: '#98f8a5'
  on-secondary-container: '#067432'
  tertiary: '#371d00'
  on-tertiary: '#ffffff'
  tertiary-container: '#563000'
  on-tertiary-container: '#e19130'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#cee5ff'
  primary-fixed-dim: '#a3cbf2'
  on-primary-fixed: '#001d32'
  on-primary-fixed-variant: '#1f4a6c'
  secondary-fixed: '#98f8a5'
  secondary-fixed-dim: '#7cdb8b'
  on-secondary-fixed: '#002109'
  on-secondary-fixed-variant: '#005321'
  tertiary-fixed: '#ffdcbd'
  tertiary-fixed-dim: '#ffb86e'
  on-tertiary-fixed: '#2c1600'
  on-tertiary-fixed-variant: '#693c00'
  background: '#fcf9f8'
  on-background: '#1c1b1b'
  surface-variant: '#e5e2e1'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  body-xl:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 34px
  body-lg:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '400'
    lineHeight: 32px
  label-action:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  label-navigation:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 20px
  label-tag:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1.25rem
  margin: 1.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1.25rem
  space-lg: 1.75rem
  space-xl: 2.5rem
---

## Brand & Style

This design system establishes a warm, dignified, and exceptionally accessible environment tailored specifically for seniors aged 65+ alongside their adult children and caregivers. The design aesthetic balances reassuring civic reliability with friendly approachability—evoking the patient confidence of an experienced, trusted personal banker rather than an intimidating cyber-security utility or an infantilizing "senior mode."

Visual principles:
- **Calm, High-Clarity Minimalism:** Heavy whitespace, singular focuses, zero visual clutter, and strict elimination of secondary visual distractions. Each screen prioritizes exactly one primary action or pedagogical step.
- **Physical Tactility & Safety:** Tangible card containers, deep structural borders (2px minimum), and generous elevation ensure clear separation between interactive objects and passive content.
- **Cognitive Ease & Reassurance:** Visual feedback uses warm, grounding tones and patient copy. Visual alarms and fear-mongering cues are explicitly prohibited; alerts are clear, analytical, and supportive.
- **Absolute Legibility First:** Target sizing exceeds WCAG AAA expectations by default, accounting for motor tremors, reduced visual acuity, presbyopia, and contrast sensitivity decline.

## Colors

The palette employs ultra-high-contrast ratios grounded in comforting, organic base tones to prevent eye strain while preserving WCAG AAA standards.

- **Background & Canvas:** Crisp yet comforting Warm Off-White (`#FAF8F4`) for the standard light mode canvas, preventing glare. In high-contrast dark mode, the canvas shifts to Deep Obsidian (`#121417`).
- **Surfaces & Cards:** Pure crisp White (`#FFFFFF`) with a 2px defining structural border in Warm Biscuit (`#E2DDD5`) to clearly segment interactive cards against the off-white background.
- **Primary Brand / Action:** Deep Navy-Teal (`#0B3C5D`) for dominant interactive buttons and active states. It delivers authoritative reassurance, paired unconditionally with stark white (`#FFFFFF`) text.
- **Text & Foreground Hierarchy:**
  - Text Primary: Near-black Charcoal (`#1A1A1A`), achieving > 12:1 contrast against light cards.
  - Text Secondary: Muted Slate (`#4A5568`), strictly meeting AAA legibility at large font sizes.
- **Status & Risk Indicators:** Color is never used alone; all semantic tones are accompanied by explicit text badges and shape-distinct iconography.
  - Safe / Verified: Deep Forest Green (`#1B7F3B`) paired with a bold Checkmark (`✓`).
  - Caution / Risky: Warm Ochre Amber (`#B26A00`) paired with an Alert Triangle (`⚠`).
  - Danger / High Scam Risk: High-Contrast Crimson (`#B3261E`) paired with an Octagonal Stop Shield (`⛉`).

## Typography

The typography scale is intentionally enlarged to prioritize legibility for presbyopic vision without feeling sterile. Built around **Inter** (supporting native iOS SF Pro drop-ins), the baseline font size never dips below 20px for content reading, with generous 1.5–1.6x line heights to eliminate visual line tracking errors.

- **Headlines (28px–34px):** Confident, direct, and bold. Titles clearly describe the screen’s explicit intent without jargon or marketing fluff.
- **Body Text (20px–22px):** Generously spaced with open counterforms. Paragraphs should be capped at 3–4 lines maximum per block to preserve cognitive focus.
- **Interactive Action Labels (22px):** Semibold weight paired with ample line clearance inside full-width touch targets.
- **System Constraints:** Dynamic Type must be supported; when scaled up by iOS accessibility settings, elements stack vertically rather than truncating with ellipses.

## Layout & Spacing

The layout philosophy is built on an uncluttered single-column fluid mobile canvas. Since fine motor accuracy declines with age, layout density is relaxed, ensuring touch separation and reducing accidental mis-taps.

- **Grid & Margins:** Fluid 1-column mobile stack with safe outer margins of 20px (`1.25rem`). Tablet layouts limit readable container widths to a maximum of 540px centered, preserving easy visual scanning.
- **Touch Target & Spacing Rules:** 
  - Absolute minimum tappable hit area is 48×48pt, with primary CTAs scaling up to 64pt in height.
  - Interactive elements must be isolated by at least 16px–20px (`space-md`) of dead space to avoid errant presses.
  - Screens must never cram competing actions above the fold. Secondary actions are kept to a minimum and positioned below primary workflows.

## Elevation & Depth

To provide unmistakable visual affordance, this design system combines low-intensity diffused shadows with tangible structural borders.

- **Tactile Outlines:** All elevated containers and interactive cards use a mandatory 2px solid perimeter outline (`#E2DDD5`). This eliminates the ambiguity of faint dropped shadows for aging eyes with reduced contrast sensitivity.
- **Soft Ambient Drops:** Surfaces float via soft, low-spread ambient shadows (`0px 4px 16px rgba(11, 60, 93, 0.06)`). The slight teal-navy tint creates harmonious depth without muddiness.
- **Active & Pressed States:** Buttons and cards exhibit physical compression upon press, depressing visually with an inner stroke darkening and reduced shadow depth to provide unmistakable tactile confirmation of a touch event.

## Shapes

The design uses balanced, friendly corner geometry that feels organic and non-aggressive while retaining structure.

- **Cards & Surfaces:** Engineered with 20px radius corners (`rounded-xl` category), framing simulator dialogs and instructional lessons softly.
- **Buttons:** Feature a matching 16px to 20px radius, balancing modern softness with clear tap-target boundaries.
- **Badges & Trust Rings:** Strictly circular (`border-radius: 9999px`) or smooth capsules to immediately differentiate metadata from tappable cards.

## Components

### Buttons
- **Primary Action Button:** Full-width container with a mandatory minimum height of 64px. Deep Navy-Teal (`#0B3C5D`) background, 16px corner radius, bold 22px centered white text.
- **Secondary / Review Button:** 64px height, pure white surface with a prominent 2px solid `#0B3C5D` outline and `#0B3C5D` text.
- **Destructive / Hang Up Button:** Crimson background (`#B3261E`), white text, accompanied by a bold phone-down or stop icon.

### Cards & Simulator Containers
- **Content Cards:** Surface white (`#FFFFFF`), 20px corner radius, 2px `#E2DDD5` outline, and 20px–24px inner padding.
- **Simulated Message Bubble (SMS/Call):** Differentiated from interface cards with an explicit label banner (e.g., `"SIMULATED TEXT MESSAGE"` in a high-contrast tag), avoiding any cognitive confusion with actual device notifications.

### Navigation (Bottom Tab Bar)
- Elevated bar with a fixed height of 84px to comfortably clear device home indicators.
- Four distinct tabs: **Home**, **Practice**, **Scam Check**, and **Family**.
- Displayed with large 28px linear stroke icons paired with persistent 16px semibold text labels below. Active tabs feature Navy-Teal coloring with an emphasized 3px indicator line.

### Circular Trust Score Meter
- Large central circular gauge (minimum 160×160px diameter) displaying overall practice safety score.
- 12px wide stroke in Deep Forest Green (`#1B7F3B`) or Warm Amber (`#B26A00`), enclosing a 34px bold score percentage and a supportive text sublabel (e.g., `"Well Protected"`).

### Linear 3-Tier Scam Likelihood Meter
- Horizontal step meter segmented into 3 distinct, clearly separated pill blocks:
  1. **Low Risk** (Forest Green)
  2. **Suspicious** (Warm Amber)
  3. **High Scam Risk** (Crimson)
- The active tier is visibly enlarged with a 3px border, high-contrast text label, and an accompanying icon (e.g., `⚠ Suspicious - Do Not Reply`).

### Interactive Form Controls
- **Checkboxes & Radios:** Scaled up to 32×32px minimum hit target, sporting 2px outlines with prominent inner check or dot states.
- **Input Fields:** 64px height with 2px borders, 20px text size, and persistent floating top labels that never disappear when typing begins.
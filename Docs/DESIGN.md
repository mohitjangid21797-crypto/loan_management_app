# LoanWise: Design

> Status: draft, 31 Oct 2026. Colors and layouts come from the logo and the phone screenshots the owner shared. Items marked **(verify)** are inferred.

## 1. Design principles
1. **Trustworthy and calm.** A finance tool for a small lender: navy base, clear numbers, no decoration that hides data.
2. **Numbers first.** Amounts are large, bold and easy to compare. Indian digit grouping everywhere.
3. **Works for everyone.** Hindi, Tamil and 10 more languages; large text; dark mode; screen readers.
4. **One-handed on a phone.** Primary actions in the lower half; bottom navigation.
5. **Never lose data silently.** Confirm destructive actions; explain errors in plain language.

## 2. Brand
- Name: **LoanWise**. Tagline: "Manage customers, loans and EMIs offline".
- Logo: navy rounded square, green zig-zag trend arrow rising to the right, two gold coin stacks, bold green "LW", white wordmark "LoanWise".
- App icon: square 1024 x 1024, no rounded corners (the phone applies its own mask), important parts inside the central 66 percent. Provide an Android adaptive icon (foreground and background layers) and a monochrome version.

## 3. Color tokens
| Token | Value | Use |
|---|---|---|
| primary | `#1E3A8A` (header and buttons; verify) | App bar, primary buttons, headings |
| primaryDeep | `#0B1650` | Splash background, dark surfaces |
| primaryMid | `#14246B` | Gradients |
| accentGreen | `#34D399` (light `#86EFAC`) | Growth, paid, success, logo arrow |
| gold | `#FFD34E` (edge `#B7791F`) | Coins, highlights |
| danger | `#EF4444` / `#F44336` | Overdue, errors, sign out |
| restoreGreen | `#059669` (verify) | Restore action |
| surface | `#FFFFFF`; background `#F8FAFC` | Cards and page |
| textPrimary / textMuted | `#111827` / `#6B7280` | Body and captions |

Status chips: Paid = green on light green; Pending = grey/blue; Overdue = red on light red; Completed loan = grey; Active loan = blue. Never use color alone; always show the text.
Dark theme: surfaces `#0F172A` and `#1E293B`, same accent colors, contrast at least 4.5:1.

## 4. Typography and spacing
- Sans-serif family (the app appears to use Inter, **verify**). Noto Sans for Devanagari, Tamil, Telugu, Bengali, Gujarati, Kannada, Malayalam, Gurmukhi, Odia, Arabic (Urdu) and Assamese, as fallback fonts.
- Scale: display 32 bold (amounts), title 22 semibold, section heading 20 bold, body 16, caption 13 muted.
- Spacing steps: 4, 8, 12, 16, 24, 32. Page padding 16 to 24. Card radius 20 to 24. Button radius 16 to 28. Minimum touch target 48 x 48.
- Money uses tabular figures where available.

## 5. Components
- **StatCard:** label (one line, ellipsis) + 40 dp icon badge, large value, caption. Two per row, wrapping; must never overflow at font scale 1.5.
- **LoanCard:** loan short ID, customer name, principal, next due date, status chip. Tap opens loan detail.
- **EMI row:** installment number, due date, amount, status chip, "Mark paid" action.
- **Empty state:** icon, one sentence, primary action.
- **ErrorView:** friendly message and a Retry button.
- **Dialogs:** title, short explanation, cancel on the left, confirm on the right; destructive confirm in red.
- **Snackbar:** short, specific message (what failed and what to do).
- Buttons: filled (primary), outlined (secondary, for example Sign out), tonal (for example Restore).
- Rows of buttons use `Expanded` or `Wrap` so they never overflow.

## 6. Navigation
Bottom bar with four tabs: **Home**, **Customers**, **Loans**, **Profile**. Settings opens from the menu (hamburger) and holds language, theme, biometric, change M-PIN, lock now, Encrypted Backup and Restore, and Security Notes. Floating "+" on Customers and Loans.

## 7. Screens
1. **Splash (3D animated):** see section 8.
2. **Create account (first launch):** name, 10-digit mobile, email, 6-digit M-PIN (+ confirm), "Create account". Inline validation.
3. **Login:** M-PIN pad (dots show digits entered), biometric button if enabled, wrong-attempt count, lockout timer.
4. **Home / Dashboard:** greeting ("Good Morning, <name>"), Loan Overview cards: Total Loans (amount, active and closed counts), EMI Due (amount, pending count), Total Customers, Documents. Recent Loans list with "View All". Overdue list.
5. **Customers:** search (name or mobile, 300 ms debounce), list newest first, add, edit, soft delete with confirm. Detail: photo, call, SMS (only if consent), loans section.
6. **Loans:** Active and Completed tabs; new-loan form with live EMI preview (customer, amount, rate, tenure, type, start date). Loan detail: summary, progress, next installment, full schedule.
7. **EMI schedule:** all installments with status; mark paid with date picker and confirm.
8. **Ledger (planned):** per customer or loan, date filter, adjustment entries.
9. **Documents / PDF:** list of generated PDFs; share and print.
10. **Profile:** photo, name, Save Changes, Statistics (customers, loans, active loans, documents).
11. **Settings:** theme, language, biometric, M-PIN, backup, restore, security notes. (Copilot was asked to remove the app-information and some security notes; **verify** current content.)

## 8. Splash logo animation (3D)
Widget: `LoanWiseLogoAnimation` (`loanwise_logo_animation.dart`). Built-in Flutter only, 3.4 s.

| Step | Timeline | Motion |
|---|---|---|
| Tile tilt-in | 0.00 to 0.35 | From rotateY -0.9 rad and rotateX 0.5 rad to flat; scale 0.6 to 1.0 (easeOutCubic, easeOutBack) |
| Arrow draw | 0.10 to 0.55 | Trend line draws along its path; arrow head at the tip (easeInOutCubic) |
| Big coins | 0.20 to 0.58 | Drop from above and spin 1.5 turns; bounceOut |
| Small coins | 0.30 to 0.66 | Same, slightly later |
| LW | 0.55 to 0.80 | Flips up from rotateX 1.3 rad, fades in (easeOutBack) |
| Wordmark | 0.75 to 1.00 | Fade in and slide up 4 percent |
Afterwards: slow 4-second idle sway (rotateY and rotateX within +-0.10 and +-0.05 rad, coins float). Hold about 0.4 s, fade to the next screen in 300 ms.
- Layout (fractions of tile size S): big stack left 0.43, top 0.19, width 0.22 (3 coins); small stack left 0.29, top 0.33, width 0.17 (2 coins); LW box left 0.28, top 0.56, width 0.46, height 0.17; wordmark top 0.80, size 0.13 S.
- Arrow points: (0.13,0.69), (0.31,0.47), (0.37,0.53), (0.55,0.35), (0.62,0.43), (0.80,0.18); line width 0.07 S.
- Reduced motion: show the finished logo immediately and skip the sway. Semantics label "LoanWise". Navigate only after BOTH the animation and the auth check finish; `AppConstants.splashDuration` at least 3.8 s.
- Performance: `RepaintBoundary`, no extra packages, 60 fps in release mode.

## 9. Responsive and accessibility rules
- Test at 320, 360, 393 and 412 dp, portrait and landscape, font scale 1.0, 1.3 and 1.5. No "RIGHT OVERFLOWED" stripes.
- Every `Text` inside a `Row` is in `Expanded` or `Flexible` with `maxLines` and ellipsis (or `FittedBox`).
- Wrap each screen body in `SafeArea`; scrollable forms so the keyboard never hides fields.
- Semantic labels on icon-only buttons; contrast at least 4.5:1; respect the system "remove animations" setting.
- Right-to-left layout for Urdu.

## 10. Localization UX
Settings language list shows each language in its own script: English, हिन्दी, தமிழ், తెలుగు, বাংলা, मराठी, ગુજરાતી, ಕನ್ನಡ, മലയാളം, ਪੰਜਾਬੀ, ଓଡ଼ିଆ, اردو, অসমীয়া, plus "System default". Change applies at once. Language names are never translated.

## 11. PDF design
A4, blue header band (app name, document title, generated time, document ID), party cards (lender and borrower), loan details table (principal, rate, tenure, type, start date, EMI, total interest, total payable, status, loan ID), EMI schedule table (repeating header, green rows for paid, no split rows), signature area, footer with page numbers. Money in Indian format; full month names.

## 12. Known UI issues
- "RIGHT OVERFLOWED" on the dashboard and profile stat cards (labels next to icons) and on the Settings "Backup Now" and "Sign Out" row. Fix with `Expanded`, ellipsis and `Wrap`.
- "Sign Out" button looks cramped under "Backup Now".
- Hindi and other Indic text in PDFs shows wrong matras (section 11, fix: HTML-based PDF).
- Placeholder test data (for example lender "John Doe") appears in generated PDFs.

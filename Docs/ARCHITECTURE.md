# LoanWise: Architecture

> Status: draft, 31 Oct 2026. Written from the project conversation. Sections marked **(verify)** describe code or settings I have not seen on the owner's machine (Nemotron and Copilot have edited the app since Phase 3). Check file paths against the repository.

## 1. Overview
LoanWise (earlier name: Loan Manager) is an **offline-first** Flutter app for **one small private lender per device**. It manages customers, loans, EMI schedules, a ledger and PDF documents. The internet is used only for optional encrypted backup to the user's own Google Drive.

- Repository: `github.com/mohitjangid21797-crypto/loan_management_app` (package `loan_management_app`)
- Platforms: Android first, iOS later (needs a Mac and an Apple Developer account)
- Default branch: `main`

## 2. Technology stack
| Area | Choice |
|---|---|
| Framework | Flutter (Dart), Material 3 |
| State management | `flutter_riverpod` (Notifier, AsyncNotifier, StreamProvider) |
| Navigation | `go_router` (auth redirect, ShellRoute for the bottom navigation) |
| Local database | `drift` on SQLite (`sqlite3_flutter_libs`) |
| Secrets | `flutter_secure_storage` (M-PIN hash and salt) |
| Settings | `shared_preferences` (theme, language, biometric flag) |
| Biometrics | `local_auth` |
| Backup | `google_sign_in`, `googleapis` (Drive `appDataFolder`), `encrypt`, `pointycastle`, `crypto` |
| PDF | `pdf` and `printing` (see section 10 for the Indic-script problem), `share_plus` |
| Other | `url_launcher` (call, SMS), `image_picker`, `intl`, `equatable`, `uuid`, `logger` |
| Planned | `flutter_local_notifications`, `timezone` |
| Tests | `flutter_test`, `mocktail` |
| Lints | `flutter_lints` plus: prefer_const_constructors, avoid_print, always_use_package_imports, require_trailing_commas |

Rules: no sync engine; no Syncfusion; no `cached_network_image`; Firebase only behind `--dart-define=ENABLE_FIREBASE=true`.

## 3. Layered structure (clean architecture)
```
presentation  ->  domain  <-  data
(UI, providers)   (pure Dart)  (Drift, DAOs, repositories)
                     ^
core / services (shared helpers, platform wrappers)
```
- **domain:** entities, enums, repository interfaces, use cases. No Flutter or Drift imports.
- **data:** Drift database, DAOs, mappers, repository implementations. Converts exceptions to typed failures.
- **presentation:** screens, widgets, Riverpod providers. Reads state, calls use cases.
- **core:** constants, error types, extensions, router, theme, utils (EMI calculator, validators, currency and date helpers, PBKDF2).
- **services:** platform wrappers (biometrics, secure storage, backup, PDF, notifications).

Suggested layout (as built in Phases 0 to 3, **verify**):
```
lib/
  core/{constants,error,extensions,router,theme,utils}
  data/{local/{database.dart,daos,tables},mappers,repositories}
  domain/{entities,enums,repositories,usecases}
  presentation/{providers,screens,widgets}
  services/
  l10n/ (ARB files, generated/)
  app.dart, main.dart
```
Files seen on the owner's machine that suggest changes (**verify**): `lib/services/backup_service.dart`, `lib/screens/settings_screen.dart`, `lib/providers/app_provider.dart`, `app_theme_provider.dart`, `language_selection_screen.dart`, `localized_text.dart`, `app_database.dart`.

## 4. State and navigation
- `AuthNotifier` (AsyncNotifier) decides the launch status: `unknown`, `needsSetup`, `locked`, `unlocked`.
- `redirectFor(status, location)` in `app_router.dart` is the only place that decides launch navigation:
  - unknown -> `/splash`; needsSetup -> create account / set M-PIN; locked -> `/login`; unlocked on splash/login -> `/dashboard`.
- Routes: splash, set-mpin (create account), login, and a ShellRoute with dashboard, customers (`add`, `:id`, `:id/edit`), loans (`add`, `:id`, schedule), settings (`profile`, `change-mpin`, backup).
- The app locks again after 60 seconds in the background (`appPaused` / `appResumed`).

## 5. Data layer
Drift database `AppDatabase`, `PRAGMA foreign_keys = ON`, schemaVersion 1 (version 2 planned).

| Table | Key columns |
|---|---|
| `customers` | id (uuid), name, mobile (10 digits, unique among non-deleted), address, notes, sms_consent, photo_path, created_at, updated_at, deleted_at (soft delete) |
| `loans` | id, customer_id, principal_paise, annual_rate_percent, tenure_months, type (`simple` or `compound`), start_date, status (`active` or `completed`), total_payable_paise, created_at |
| `emi_schedules` | id, loan_id, installment_no, due_date, emi_paise, principal_part_paise, interest_part_paise, remaining_balance_paise, status (`pending` or `paid`), paid_date |
| `ledger_entries` | id, customer_id, loan_id, kind (disbursement, payment, adjustment), debit/credit, amount_paise, balance_after_paise, created_at. **Append-only.** |
| `lender_profile` | name, photo path, currency symbol, default rate (email and mobile added by the account screen, **verify**) |

Planned schemaVersion 2 migration: indexes on `customers(mobile)`, `loans(customer_id, status)`, `emi_schedules(loan_id, due_date, status)`, `ledger_entries(customer_id, created_at)`, plus the email column.

Transactions (each runs in ONE Drift transaction):
1. **Create loan:** check customer, insert loan, insert all EMI rows, write the disbursement ledger entry.
2. **Mark EMI paid:** check not found, already paid and out of order; mark paid; write a credit ledger entry; if no pending EMIs remain, set the loan to completed.

## 6. Domain rules
- **Money:** integer paise, never doubles. Display with Indian digit grouping (1,23,456.00) and the rupee symbol.
- **Dates:** stored at UTC midnight. Installment i is due i months after the start date, same day of month, clamped to the month's end (`AppDateUtils.addMonthsClamped`).
- **Overdue:** pending and due date before today. Computed, never stored.
- **Simple interest:** `interest = P * rate * (n/12) / 100`; `EMI = (P + interest) / n`; interest spread evenly.
- **Compound (reducing balance):** `r = rate/12/100`; `EMI = P*r*(1+r)^n / ((1+r)^n - 1)`; each month `interest = round(balance * r)`.
- Each EMI is rounded to the paisa; the leftover goes to the **last installment** so the schedule sums exactly.
- Rate and tenure are frozen at loan creation.
- **Ledger:** disbursement is a debit of the **total owed (principal + interest)**, each payment is a credit, so the balance is exactly 0 when the loan is fully paid. *(Assumption to confirm with the owner.)*
- Out-of-order payment is rejected by default.
- A customer with an active loan cannot be deleted; deletion is soft.

## 7. Security
- **M-PIN:** 4 or 6 digits (the account screen requests 6), stored only as a salted PBKDF2-HMAC-SHA256 hash (16-byte salt, at least 100,000 iterations) in secure storage.
- 5 wrong attempts lock the app for 30 seconds, growing on repeats. Auto-lock after 60 seconds in the background.
- Biometric unlock can only be turned on after one successful biometric check.
- Change M-PIN requires the old M-PIN. "Lock now" is available in Settings.
- Customer data never leaves the phone except inside the encrypted backup.
- Secrets (keystore, passwords, `key.properties`) are never committed.

## 8. Encrypted backup and restore
- **Storage:** Google Drive hidden `appDataFolder` (scope `drive.appdata`, a non-sensitive scope). Keep the latest 5 backups.
- **File format:** magic bytes `LMBK`, a version byte, 16-byte salt, 12-byte IV, ciphertext + GCM tag.
- **Crypto:** AES-256-GCM; key from PBKDF2-HMAC-SHA256 (200,000 iterations) over a user-chosen backup password that is never stored.
- **Backup flow:** sign in -> choose password -> copy database and photos -> encrypt on device -> upload -> prune to 5.
- **Restore flow:** sign in -> list backups -> password -> decrypt -> validate the database -> swap files atomically -> roll back on any failure -> user sets a new M-PIN (the M-PIN is not in the backup).
- A lost backup password cannot be recovered.

Google Cloud setup (needed for sign-in to work):
- One Google Cloud project holds: the **Web client** (its ID is the `serverClientId` in `backup_service.dart`), the **Android clients** (package name + SHA-1 for debug and release), the Drive API, the consent screen (`drive.appdata`), and test users.
- Intended single project: `loanmanagementapp-513215` (project number `773939013768`). The older project `loanmanagementapp-512712` (`698864958264`) still holds the old web client ID that the code uses (**must be replaced**, see TASKS).
- Release SHA-1: `5F:E0:BD:B7:99:66:99:89:17:A4:D5:2F:87:A4:F1:8B:3E:9C:3F:6F`. The debug SHA-1 comes from the debug keystore on the developer's computer.
- "Error 10" means the package name, SHA-1 or project does not match.

## 9. Localization
- Flutter `gen-l10n`; ARB files in `lib/l10n/`; generated code in `lib/l10n/generated/` (never hand-edited).
- English, Hindi and Tamil fully translated. Ten stub files (te, bn, mr, gu, kn, ml, pa, or, ur, as) fall back to English. Target: 13 languages with a language picker.
- Numbers, dates and money are formatted with `intl`, not stored in translated strings.

## 10. PDF generation
- Documents: loan agreement or statement, EMI schedule, completion certificate. A4.
- **Known problem:** the Dart `pdf` package does not shape Indic scripts. Hindi shows wrong matras and conjuncts (for example `प्रतिवर्ष` becomes `प्रतविर्ष`).
- **Decision:** for Indic scripts, build the PDF from HTML with `Printing.convertHtml` (platform web engine shapes text correctly). Keep the `pw.Document` path for English. Fallback: render each page as an image with `RepaintBoundary`.
- Use full month names (not short forms with the abbreviation sign).

## 11. Notifications (planned)
`flutter_local_notifications` + `timezone`: a notification at 9:00 local time on each EMI due date and the day before. Schedules are rebuilt when loans change.

## 12. Error handling
`Result<T>` (`Success` / `Err`), typed `Failure`s (network, database, not found, duplicate mobile, active loan, validation), `ExceptionHandler.guard`, validators returning a `ValidationError` enum that maps to localized text. Backup errors must show the real step that failed, not only "Backup failed".

## 13. Testing and CI
- Unit tests: validators, EMI calculator, currency and date helpers, PBKDF2, repositories (with fakes), use cases.
- Widget tests: launch flow (splash, create account, login), overflow checks at 320, 360 and 412 dp and font scale 1.5.
- To do: dashboard aggregation test, integration test, CI (GitHub Actions: analyze + test).

## 14. Build, signing and release
- Release keystore: `C:\Users\mohit\keys\loanwise-release.jks`, alias `loanwise` (PKCS12, one password for store and key; **the password is not recorded here**). Back it up.
- `android/key.properties` (git-ignored) feeds the `release` signing config. `apksigner verify --print-certs` confirmed the release APK is signed with this key.
- Change `applicationId` from `com.example.loan_management_app` before publishing; register the new name in Google Cloud.
- Remove the Google Services Gradle plugin, or add `google-services.json`, otherwise `assembleRelease` fails.
- Output for the Play Store: `flutter build appbundle --release`.

## 15. External services
| Service | Use |
|---|---|
| Google Drive API | Encrypted backup storage (user's own Drive) |
| Google Cloud OAuth | Sign-in for backup |
| Firebase Hosting (project `loanmanagementapp-8f884`) | Privacy policy and home page for the Google consent screen. Live at https://loanmanagementapp-8f884.web.app (privacy page at `/privacy.html`, verify). Firebase console: https://console.firebase.google.com/project/loanmanagementapp-8f884/overview. Site folder on the owner's PC: `C:\Users\mohit\loanwise-site`; redeploy with `firebase deploy --only hosting` |
| Firebase Auth / Firestore | **Not used.** Only behind `ENABLE_FIREBASE` if ever added |

## 16. Open architecture questions
1. Confirm the EMI formulas and the ledger disbursement rule against real loans.
2. Is the 6-digit M-PIN account screen implemented as specified (name, mobile, email, M-PIN)?
3. Which Nemotron-built files replaced the Phase 0 to 3 structure?

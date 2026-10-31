# LoanWise: Project Memory

> Purpose: context for any AI coding assistant (Nemotron, Copilot, Claude Code) or helper working on this repo. Read this first. Status: 31 Oct 2026. Items marked **(verify)** are unconfirmed. **Never put passwords, keystore files or `key.properties` in this file or in git.**

## 1. Identity
- App: **LoanWise** (earlier "Loan Manager"). Offline-first Flutter app for ONE small private lender per device: customers, loans, EMI schedules, ledger, PDFs, optional encrypted Google Drive backup.
- Repo: `github.com/mohitjangid21797-crypto/loan_management_app`, package `loan_management_app`, branch `main` (other branches: `phase-3-loans`, `fix-indic-pdf`, `feature-splash-login`, **verify**).
- Owner: Mohit Suthar. Windows PC, VS Code, PowerShell. Local path: `C:\Users\mohit\Placement Preparation\loan_management_app`.
- Current `applicationId`: `com.example.loan_management_app` (must change before publishing; plan: `com.mohit.loanwise`).

## 2. Non-negotiable rules
1. **Money = integer paise.** Never double. Display with Indian grouping (1,23,456.00) and the rupee symbol.
2. **Dates = UTC midnight.** Overdue is computed (pending and due before today), never stored.
3. **Ledger is append-only.** Corrections are new entries.
4. Loan creation (loan + schedule + ledger) and mark-paid (EMI + ledger + loan completion) are each ONE Drift transaction.
5. **Offline-first.** No network calls except Google sign-in and Drive backup/restore.
6. M-PIN only as a salted PBKDF2-HMAC-SHA256 hash in secure storage. Never log it.
7. No sync engine, no Syncfusion, no `cached_network_image`. Firebase only behind `--dart-define=ENABLE_FIREBASE=true`.
8. Every user-visible string goes through ARB localization. Never hand-edit `lib/l10n/generated/`.
9. Every `Text` in a `Row` needs `Expanded`/`Flexible` or `maxLines` + ellipsis. No overflow at 320 dp and font scale 1.5.
10. Do not change backup, encryption or database logic unless the task says so.

## 3. Conventions
- Clean architecture: domain (pure Dart) <- data (Drift, DAOs, repositories) -> presentation (Riverpod, screens, widgets); `core/` and `services/` for helpers.
- Riverpod (Notifier/AsyncNotifier/StreamProvider), `go_router`; launch navigation only through `redirectFor()` in `app_router.dart`.
- Errors: `Result<T>`, typed `Failure`s, `ExceptionHandler.guard`; show specific messages.
- Lints: prefer_const_constructors, avoid_print, always_use_package_imports, require_trailing_commas.
- Commits small and clear; each task on a branch; push after green tests.

## 4. Commands (PowerShell)
```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
flutter run -d <device id>
flutter build apk --release
flutter build appbundle --release
```
Check release signing: `apksigner verify --print-certs build\app\outputs\flutter-apk\app-release.apk` (apksigner is in `%LOCALAPPDATA%\Android\Sdk\build-tools\<version>`). `adb` is in `%LOCALAPPDATA%\Android\Sdk\platform-tools` and is not on PATH.

## 5. Key facts and IDs (no secrets)
- Release keystore: `C:\Users\mohit\keys\loanwise-release.jks`, alias `loanwise`, PKCS12 (one password for store and key; password is kept by the owner only). Release SHA-1: `5F:E0:BD:B7:99:66:99:89:17:A4:D5:2F:87:A4:F1:8B:3E:9C:3F:6F`.
- `android/key.properties` (git-ignored) must hold storePassword, keyPassword, keyAlias=loanwise, storeFile (double backslashes). The release build must not silently fall back to the debug key (Copilot added such a fallback; **verify and tighten**).
- Google Cloud projects: `loanmanagementapp-513215` (number 773939013768) is the project to keep; older `loanmanagementapp-512712` (number 698864958264) holds the old web client ID that `lib/services/backup_service.dart` (about line 64) still uses. **The web client and Android clients must be in the same project.**
- Firebase project `loanmanagementapp-8f884`: used for Hosting only (privacy policy and home page). Hosting URL: https://loanmanagementapp-8f884.web.app (privacy page `/privacy.html`, verify). Console: https://console.firebase.google.com/project/loanmanagementapp-8f884/overview. Site source: `C:\Users\mohit\loanwise-site` (`firebase deploy --only hosting`). `assembleRelease` failed because the Google Services plugin is applied but `google-services.json` is missing; remove the plugin unless Firebase is really used.
- Backup format: `LMBK` + version byte + 16-byte salt + 12-byte IV + AES-256-GCM ciphertext; PBKDF2-HMAC-SHA256 200,000 iterations; keep latest 5; Drive scope `drive.appdata`.

## 6. Current state
**Done (as written, never compiled by the original author, verify by running):** Phases 0 to 3: M-PIN auth, profile, customers, loans, EMI schedule and payments, ledger data layer, dashboard, settings, en/hi/ta localization.
**Built by other tools (verify):** Home/Customers/Loans/Profile bottom navigation, Documents counter and PDFs, Settings with Encrypted Backup/Restore, language selection screen, theme provider with tests, Google Drive sign-in flow.
**Written but not integrated:** `loanwise_logo_animation.dart` (3D splash widget).
**Verified:** release APK is signed with the release keystore (apksigner SHA-1 matches).

## 7. Known issues
1. Google sign-in: "error 10" (client/SHA-1/project mismatch) and "Access blocked: has not completed verification" (add the Gmail as a test user in the project in use).
2. Backup shows only "Backup failed": needs per-step error reporting; likely Drive API or scope issue in the project in use.
3. Overflow stripes on stat cards (Total Customers, Active Loans) and the Settings backup button row.
4. Hindi and other Indic PDF text has wrong matras (the `pdf` package cannot shape Indic scripts).
5. Generated PDFs use placeholder lender data ("John Doe").
6. `applicationId` is `com.example...`.
7. Release build fails without `google-services.json` or removal of the Google Services plugin.
8. Copilot monthly credit limit reached; resets 1 Nov 2026.

## 8. Decisions log
| Decision | Why |
|---|---|
| Offline-first, local SQLite | Privacy, works without internet, one lender per phone |
| Backup to user's own Drive app-data folder, encrypted on device | No server to run or secure; backup unreadable by anyone else |
| Disbursement ledger entry = principal + interest (assumption) | Balance reaches exactly 0 when fully paid |
| EMI formulas: simple flat; compound reducing balance (assumption) | Defaults from the spec; confirm with real loans |
| Reject out-of-order EMI payment by default | Prevents accidental mistakes |
| Soft delete for customers | Keep history |
| PDFs for Indic scripts via `Printing.convertHtml` | `pdf` package cannot shape Indic text |
| One Google Cloud project for web + Android clients | Avoids OAuth error 10 |
| Firebase Hosting only for privacy page | Firebase Auth/Firestore not needed |

## 9. Glossary
EMI (equated monthly installment), paise (1/100 rupee), principal, simple vs compound (reducing balance), ledger (debit and credit entries per customer), M-PIN (4 or 6 digit app PIN), SHA-1 (signing key fingerprint), appDataFolder (hidden Google Drive folder only the app can read), ARB (Flutter localization file).

## 10. Working notes for assistants
- The owner works on Windows and pastes commands into PowerShell: give PowerShell, not bash.
- Prefer short step lists, exact commands and the reason for each fix.
- If you cannot verify something, say so. Do not claim a build passes unless you ran it.
- Ask before changing the database schema, the encryption format or the package name.
- Update `TASKS.md` and this file when decisions change.

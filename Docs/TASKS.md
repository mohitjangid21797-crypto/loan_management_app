# LoanWise: Tasks

> Status: 31 Oct 2026. `[x]` done, `[~]` in progress or partly done, `[ ]` to do. Priority: P0 must have, P1 should have, P2 later. "Verify" = I could not confirm it in the code.

## A. Foundation and build health (P0)
- [x] Phases 0 to 3 written: auth, profile, customers, loans, EMI payments, dashboard, settings, en/hi/ta (never compiled by the author)
- [ ] Run `flutter pub get`, `build_runner`, `flutter analyze`, `flutter test`; fix every error
- [ ] Confirm which files Nemotron/Copilot replaced; update `ARCHITECTURE.md` file paths
- [ ] Write the missing dashboard aggregation test
- [ ] Merge `phase-3-loans` and other feature branches into `main` (check which are merged)
- [ ] Add `.gitignore` entries: `android/key.properties`, `*.jks`, `*.keystore`

## B. Launch flow and splash (P1)
- [x] 3D animated logo widget written (`loanwise_logo_animation.dart`), preview GIF made
- [ ] Integrate the widget into the splash screen; navigate only after animation and auth check finish
- [~] Create-account screen (name, 10-digit mobile, email, 6-digit M-PIN) then Dashboard (requested, verify whether implemented)
- [ ] Add email column and migration (schemaVersion 2)
- [ ] Respect "remove animations"; test the launch flow

## C. UI fixes (P0)
- [ ] Fix overflow on dashboard and profile stat cards ("Total Customers", "Active Loans")
- [ ] Fix overflow of the Settings "Backup Now" and "Sign Out" row (use `Expanded` or `Wrap`)
- [ ] Search all screens for other overflows; widget tests at 320, 360, 412 dp and font scale 1.5
- [ ] Remove placeholder data ("John Doe") from PDFs and use the real lender profile
- [ ] Performance pass: const widgets, `ListView.builder`, `select()` in providers, dispose controllers
- [ ] Test a release build with `flutter run --release` for smoothness

## D. Google sign-in and Drive backup (P0 to P1)
- [x] Google Drive API enabled in project 512712; release keystore created; release APK signed correctly
- [~] Consolidate on ONE Google Cloud project (`513215`):
  - [ ] Enable Drive API
  - [ ] Consent screen: branding, Audience = Testing, add the Gmail as a test user
  - [ ] Data Access: add `drive.appdata` (plus email, profile, openid)
  - [ ] Create a **Web application** client; put its ID in `backup_service.dart` (replace the old `698864958264-...` ID)
  - [ ] Android clients: release SHA-1 and debug SHA-1 with the final package name (create the release one in this project; delete duplicates in the other)
- [ ] Add per-step error reporting to backup and restore (sign-in, read DB, encrypt, upload, prune)
- [ ] Confirm backup creates a file in `appDataFolder`; restore on a second device or after reinstall
- [ ] Show "Last backup" time; warn that a forgotten password cannot be recovered
- [ ] Tests for encrypt/decrypt round trip, wrong password, corrupt file, rollback

## E. Release and package setup (P0 before publishing)
- [ ] Change `applicationId` and namespace from `com.example...` (plan: `com.mohit.loanwise`); update MainActivity package, Google Cloud clients and Firebase app
- [ ] Remove the Google Services Gradle plugin (or add `google-services.json`) so `assembleRelease` passes
- [ ] Make the release build fail when signing values are missing (no silent debug fallback)
- [ ] Back up `loanwise-release.jks` and keep the password safe; consider changing it to a stronger one (`keytool -storepasswd`)
- [ ] Build `flutter build appbundle --release`; verify signature with `apksigner`
- [ ] App icon (adaptive and monochrome) and native splash
- [ ] Play Store listing: description, screenshots, data-safety form, content rating
- [ ] iOS later: Mac or cloud Mac, bundle ID, iOS OAuth client, `Info.plist` URL scheme, Apple Developer account

## F. Privacy page and consent screen (P1)
- [x] Firebase Hosting deployed from `C:\Users\mohit\loanwise-site`: https://loanmanagementapp-8f884.web.app (console: https://console.firebase.google.com/project/loanmanagementapp-8f884/overview)
- [ ] Check that `/privacy.html` opens and shows the real contact email (not the placeholder); redeploy with `firebase deploy --only hosting` after any change
- [ ] Put the home page and privacy URLs in Google Auth Platform -> Branding; add `web.app` as an authorized domain
- [ ] Before going to production: Audience -> Publish app; review brand verification (logo)

## G. Documents / PDF (P1)
- [ ] Fix Indic scripts: build PDFs for hi, ta and other Indic languages with `Printing.convertHtml` (fallback: page images)
- [ ] Full month names in the user's language
- [ ] Ledger screen: per customer or loan, date filter, adjustment entries
- [ ] PDF list screen; share and print; completion certificate
- [ ] Test PDFs on a real phone in Hindi and Tamil

## H. Localization (P1)
- [ ] Move every hard-coded string into `app_en.arb`; add the 13 locale files
- [ ] Translate hi and ta fully (native speaker review); other languages or English fallback
- [ ] Language picker with native names and "System default"; Urdu right-to-left check
- [ ] Noto Sans fonts for all scripts (app and PDFs)
- [ ] Test: ARB key parity and widget tests in hi and ta

## I. Notifications, performance and quality (P1 to P2)
- [ ] Local notifications at 9:00 on the due date and the day before (timezone-aware)
- [ ] Pagination over 200 rows; DB indexes via schemaVersion 2 migration
- [ ] Integration test (create customer -> create loan -> pay EMI -> dashboard)
- [ ] CI (GitHub Actions: pub get, analyze, test)
- [ ] README and screenshots

## J. Decisions needed from the owner
- [ ] Confirm EMI formulas (simple flat; compound reducing balance) with a real loan example
- [ ] Confirm ledger rule (disbursement = principal + interest)
- [ ] Partial payments? Late fees?
- [ ] Final package name and publish plan (Play Store, App Store)
- [ ] Keep Firebase out of the app, or add Auth/Firestore behind `ENABLE_FIREBASE`?

## Suggested order for the next sessions
1. Section A (build and tests green) and C (overflow fixes).
2. Section D (single Google project, working backup) and E (package name, release build).
3. Section F (privacy page), then G (PDF fix), then H (localization).
4. Sections B, I, then Play Store release; iOS last.

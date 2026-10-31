# LoanWise: Project Requirements Document (PRD)

> Status: draft, 31 Oct 2026. Based on the original 17-page spec (`loan_management_app.pdf`) and decisions made in the project conversation. Priorities: P0 = must have for first release, P1 = should have, P2 = later.

## 1. Product summary
LoanWise is a mobile app for **small private lenders** (people who lend money to individuals) to track customers, loans, monthly EMI payments and what each customer owes. One lender uses the app per phone. It works **offline**. The internet is used only for optional encrypted backup to the lender's own Google Drive.

## 2. Goals
1. Replace paper notebooks and spreadsheets with an accurate, private record of loans and payments.
2. Show at a glance what is due, what is overdue and how much interest has been earned.
3. Produce professional documents (agreement, statement, certificate) in the lender's language.
4. Keep customer data on the phone, protected by an M-PIN and optional biometrics, with encrypted backup and restore.

## 3. Non-goals (for now)
- Multi-user accounts, staff roles, or syncing between devices.
- A server database (Firebase Auth or Firestore) as the main store.
- Online payment collection, credit scoring, or bank integrations.
- Automatic SMS sending without customer consent.
- Web or desktop versions (mobile only; iOS after Android).

## 4. Users
**Primary: the lender.** A small business owner, often in India, who lends to a few to a few hundred people. Comfortable with a phone, may prefer Hindi, Tamil or another regional language, not an accountant.
**Secondary: the borrower.** Receives documents (PDF) and, with consent, SMS or call from the lender. Does not use the app.

## 5. User stories
| ID | Story | Priority |
|---|---|---|
| US-1 | As a lender I protect the app with an M-PIN (and biometrics) so no one else sees my records. | P0 |
| US-2 | I add, edit, search and delete customers. | P0 |
| US-3 | I create a loan with amount, rate, tenure, type and start date and see the EMI before saving. | P0 |
| US-4 | I see every installment of a loan and mark one paid with a date. | P0 |
| US-5 | I see on a dashboard total lent, interest earned, active loans, overdue and this month's dues. | P0 |
| US-6 | I get reminders on due dates. | P1 |
| US-7 | I view a customer's ledger and add adjustments. | P1 |
| US-8 | I generate and share a loan agreement, statement and completion certificate as PDF in my language. | P1 |
| US-9 | I back up to my Google Drive with a password and restore on a new phone. | P1 |
| US-10 | I use the app in Hindi, Tamil and other Indian languages. | P1 |
| US-11 | I choose light, dark or system theme. | P2 |
| US-12 | I see an animated LoanWise splash on launch. | P2 |

## 6. Functional requirements
### 6.1 Account and security
- FR-1 First launch: create account with name, 10-digit mobile, email and a 6-digit M-PIN (entered twice). Return launches ask for the M-PIN (or biometrics).
- FR-2 M-PIN stored only as a salted PBKDF2-HMAC-SHA256 hash (16-byte salt, 100,000 or more iterations).
- FR-3 After 5 wrong attempts lock for 30 seconds, increasing on repeats.
- FR-4 Lock again after 60 seconds in the background; manual "Lock now".
- FR-5 Biometric unlock is optional and can be enabled only after one successful biometric check.
- FR-6 Changing the M-PIN requires the current M-PIN.
- FR-7 Lender profile: name, photo (copied into app storage), currency symbol, default rate.

### 6.2 Customers
- FR-8 Fields: name (required), mobile (10 digits, starts with 6 to 9, unique among active customers), address, notes, SMS consent, photo.
- FR-9 Search by name or mobile, case-insensitive, 300 ms debounce, newest first.
- FR-10 Delete is a soft delete with confirmation, blocked if the customer has an active loan.
- FR-11 Detail screen has a Call button and an SMS button (only when consent is on) and lists the customer's loans.

### 6.3 Loans
- FR-12 Create a loan: customer, amount (greater than 0), annual rate (0 to 100), tenure (1 to 600 months), type (simple or compound), start date.
- FR-13 Live EMI, total interest and total payable preview before saving.
- FR-14 Rate and tenure are fixed after creation.
- FR-15 The full schedule is generated at creation: due dates on the same day each month (clamped to month end), each EMI rounded to the paisa, rounding leftover in the last installment so the schedule sums exactly.
- FR-16 Loans list has Active and Completed tabs; detail shows summary, progress and schedule.

### 6.4 EMI payments
- FR-17 Status is paid, pending or overdue (overdue = pending and due before today, computed).
- FR-18 "Mark paid" asks for confirmation and a payment date.
- FR-19 Paying out of order is rejected by default; paying twice is rejected.
- FR-20 Paying the last installment completes the loan.

### 6.5 Ledger
- FR-21 Append-only entries. Creating a loan writes a debit of the total owed; each paid EMI writes a credit; the balance is exactly 0 when the loan is fully paid.
- FR-22 Creating a loan and marking an EMI paid are each ONE atomic transaction.
- FR-23 (P1) Ledger screen per customer or loan with date filter and adjustment entries (corrections are new entries, never edits).

### 6.6 Dashboard
- FR-24 Total disbursed (sum of principal), interest earned (interest part of paid EMIs), active loan count, overdue count, this month's pending due total, number of documents, and a list of overdue installments that opens the loan.

### 6.7 Documents (PDF)
- FR-25 Loan agreement and statement, EMI schedule, completion certificate; A4; share and print.
- FR-26 Correct rendering of Indic scripts (Hindi, Tamil and the other supported languages): matras and conjuncts must be right.
- FR-27 Full month names in the user's language; Indian number format.
- FR-28 A list of generated documents.

### 6.8 Backup and restore
- FR-29 Sign in with Google; back up to the hidden Drive app-data folder.
- FR-30 Encrypt on the device with AES-256-GCM, key from PBKDF2 (200,000 iterations) over a user-chosen password that is never stored. File magic `LMBK`, version byte, salt, IV, ciphertext.
- FR-31 Keep the latest 5 backups.
- FR-32 Restore: list backups, ask for the password, decrypt, validate the database, swap files atomically, roll back on failure. The user then sets a new M-PIN.
- FR-33 Show specific, readable errors (which step failed) instead of only "Backup failed".
- FR-34 Warn clearly that a forgotten password cannot be recovered.

### 6.9 Notifications (P1)
- FR-35 Local notification at 9:00 local time on each EMI due date and the day before; timezone-aware; rebuilt when loans change.

### 6.10 Settings and localization
- FR-36 Theme: system, light, dark. Language: English, Hindi, Tamil, Telugu, Bengali, Marathi, Gujarati, Kannada, Malayalam, Punjabi, Odia, Urdu, Assamese, plus system default.
- FR-37 All user-visible text comes from ARB files; no hard-coded strings.

### 6.11 Launch experience (P2)
- FR-38 3D animated LoanWise splash (3.4 s), then Create account or Login, then Dashboard. Navigate only after both the animation and the auth check finish. Respect the system "remove animations" setting.

## 7. Non-functional requirements
- **Offline-first:** every feature except backup and restore works with no connection.
- **Privacy:** no analytics or tracking; no customer data leaves the phone except in the encrypted backup.
- **Accuracy:** money in integer paise; no rounding drift; schedules always sum to the total.
- **Performance:** 60 fps in release mode; lists lazy-loaded; pagination beyond 200 rows; app starts within about 4 seconds including the splash.
- **Layout:** no overflow at 320 to 412 dp width and font scale up to 1.5.
- **Accessibility:** semantic labels, contrast at least 4.5:1, touch targets at least 48 dp.
- **Reliability:** database changes are atomic; restore never leaves a half-written database.
- **Quality gate:** `flutter analyze` with zero issues and `flutter test` all green before each merge.
- **Platforms:** Android 7+ first; iOS later.

## 8. Business rules (summary)
1. Simple interest: `interest = P * rate * (n/12) / 100`, `EMI = (P + interest) / n`.
2. Compound (reducing balance): `EMI = P*r*(1+r)^n / ((1+r)^n - 1)`, `r = rate/12/100`.
3. Overdue is computed, never stored. Ledger is never edited.
4. Mobile numbers are unique among non-deleted customers.
5. These formula choices and the "disbursement = total owed" ledger rule are **assumptions to be confirmed** against real loans.

## 9. Constraints and assumptions
- One lender per device; the developer is a solo student developer using AI coding tools (Nemotron 3 Ultra, Copilot) and Claude.
- Development on Windows; iOS builds need a Mac or a cloud Mac service and an Apple Developer account.
- Google sign-in for backup needs one correctly configured Google Cloud project; the consent screen starts in Testing mode (test users only).
- The package name `com.example.loan_management_app` must change before Play Store release.

## 10. Release criteria (first public version)
1. All P0 and P1 requirements pass their tests; analyzer clean.
2. Release APK/AAB signed with the release keystore; Google sign-in tested on a release build installed on a real phone.
3. PDFs checked visually in Hindi and Tamil.
4. Privacy policy and home page published (https://loanmanagementapp-8f884.web.app); consent screen branding complete.
5. Store listing: name, icon, screenshots, short and full description, data-safety form.

## 11. Risks
| Risk | Mitigation |
|---|---|
| Code never compiled or run by the original author of Phases 0 to 3 | Run analyze and tests, fix errors, device test |
| Google OAuth mismatch (error 10, access blocked) | Single project; register debug and release SHA-1; add test users |
| Lost release keystore or password | Back up the file and password; never commit |
| Lost backup password | Clear warning in the UI |
| Indic PDF shaping | HTML-based PDF path |
| Wrong EMI maths for the lender's practice | Confirm formulas with real examples |
| AI tool credit limits (Copilot) | Keep prompts and docs in the repo; use several tools |

## 12. Open questions
1. Which interest formula do real lenders expect for "compound"? Monthly reducing balance or compounding per period?
2. Should the ledger disbursement be principal only, or principal + interest?
3. Is partial payment (less than the EMI) needed?
4. Is a late fee needed?
5. Final app name and package name (LoanWise, `com.mohit.loanwise`?).
6. Will the app be published on Google Play and the App Store?

## 13. Roadmap
- **Phase 0 to 3 (done in code, unverified build):** foundation, auth and profile, customers, loans and EMI payments, dashboard.
- **Phase 4:** ledger screen, PDFs.
- **Phase 5:** encrypted Drive backup and restore.
- **Phase 6:** notifications, pagination, indexes, integration test, CI, release signing, icon and splash, README and privacy policy.
- **Next:** localization to 13 languages, UI polish and overflow fixes, Play Store release, iOS.

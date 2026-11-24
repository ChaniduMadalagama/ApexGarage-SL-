# Chapter 7: Testing and Verification

This chapter outlines the test plan, testing strategy, observed automated backend test results, Flutter static analysis results, system test cases, and defects/observations addressed during development.

---

## 7.1 Test Plan

*Table 18: Test plan overview*

| Item | Plan |
| :--- | :--- |
| **Objective** | Verify that all functional requirements, security controls (RBAC, IDOR, tenant isolation), and static code quality rules work as specified |
| **Scope** | Laravel 13 API (`/api/v1/*`), Livewire 4 portals (`/login`, `/admin`, `/seller`), domain actions/jobs, and Flutter mobile codebase (`lib/`) |
| **Techniques** | Automated feature & unit testing (Pest), HTTP contract assertions, policy/authorization negative tests (`401`/`403`/`422`), and static analysis |
| **Environment** | macOS development host; PHP 8.3 + SQLite in-memory/file test DB; Pest 4.7; Flutter SDK (`flutter analyze`) |
| **Test Data** | `DatabaseSeeder` demo accounts (`colombo-hq` tenant), factories (`TenantFactory`, `UserFactory`, `VehicleFactory`), fake storage (`Storage::fake('public')`) |
| **Entry Criteria** | Database migrations applied; `composer` and `flutter pub get` dependencies resolved |
| **Exit Criteria** | All automated Pest tests pass; zero errors and zero warnings in `flutter analyze` |

*Table 19: Test strategy*

| Level | Tool | What It Covers |
| :--- | :--- | :--- |
| **Unit Testing** | Pest (`backend/tests/Unit/`) | `TenantContext` state management (`hasTenant`, `setTenantId`, `getTenantId`, `clear`) |
| **Feature & Integration** | Pest + Livewire + Sanctum (`backend/tests/Feature/`) | Auth, `+94` normalization, RBAC, `VehiclePolicy` IDOR, multi-tenancy, Garage, Marketplace, Workshops, Meets, Crews, Seller Mode, Admin/Seller Livewire portals |
| **Static Analysis (Mobile)** | `flutter analyze` (`very_good_analysis`) | Dart type safety, null safety, widget/hook rules, deprecated APIs |

---

## 7.2 Automated Backend Tests & Static Analysis

### Backend Automated Test Results (`php artisan test`)
Running `php artisan test` in `backend/` executed the full Pest suite:
- **Result:** **17 tests passed, 202 assertions, 0 failures** (duration: **630 ms**).

*Table 20: Automated backend test suites (Pest)*

| Test File | Scope Covered | Result |
| :--- | :--- | :--- |
| `tests/Unit/ExampleTest.php` | `TenantContext` lifecycle and isolation helpers | Pass |
| `tests/Feature/ApexGaragePlatformTest.php` | Web portals (`/`, `/login`, `/admin`, `/seller`), security headers, vetting, listing moderation, ad management, Sanctum auth, Spatie RBAC, domain actions/jobs, cache invalidation, `BelongsToTenant` isolation | Pass |
| `tests/Feature/MobileApiTest.php` | SL mobile `+94` registration, token revocation, `VehiclePolicy` IDOR & forged `X-Tenant-ID` rejection, media upload, garage CRUD, marketplace search/histogram/chat/reserve, workshop booking, meets, crews, live presence, comments, Seller mobile API | Pass |

*(Total across all 3 files: 17 Pest test cases, 202 assertions, 100% pass rate.)*

### Flutter Static Analysis Results (`flutter analyze`)
Running `flutter analyze` across the Flutter workspace completed in **2.0 seconds**:
- **Errors:** **0**
- **Warnings:** **0**
- **Info notices:** **534** (stylistic `very_good_analysis` lints such as `directives_ordering`, `prefer_const_constructors`, and Flutter SDK `deprecated_member_use` notices for `package:flutter/material.dart` / `withOpacity` on newer Flutter toolchains).

*Table 21: Static analysis summary (`flutter analyze`)*

| Severity | Count | Notes |
| :--- | :---: | :--- |
| **Error** | 0 | Clean compilation / zero type or syntax errors |
| **Warning** | 0 | Zero analyzer warnings |
| **Info** | 534 | Code-style ordering and SDK deprecation hints only |

---

## 7.3 System Test Cases

*Table 22: System test cases*

| ID | Test Case | Input / Action | Expected Result | Observed Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-01** | SL mobile registration | Register with `077 123 4567` | Normalized to `+94771234567`, Sanctum token issued | Pass (Pest) |
| **TC-02** | Token revocation | Call `POST /api/v1/auth/logout` | Token deleted; subsequent `/auth/me` returns `401` | Pass (Pest) |
| **TC-03** | IDOR protection on vehicles | User B requests User A's vehicle | `403 Forbidden` via `VehiclePolicy` | Pass (Pest) |
| **TC-04** | Forged tenant header | Send `X-Tenant-ID: 999` on API request | Header ignored; server uses authenticated user's tenant | Pass (Pest) |
| **TC-05** | Multi-tenant isolation | Query models across two tenants | `BelongsToTenant` hides other tenant's records | Pass (Pest) |
| **TC-06** | Media upload & garage CRUD | Upload image, create vehicle, build log, service record | `201 Created`, `photo_url` persisted | Pass (Pest) |
| **TC-07** | Marketplace histogram & filter | Request `/marketplace/parts` & `/histogram` | Filtered parts + price buckets returned | Pass (Pest) |
| **TC-08** | Buyer-seller chat & reserve | Send chat message, reserve part | Inquiry created, message saved, part reserved | Pass (Pest) |
| **TC-09** | Workshop bay booking | Check slots, `POST /mechanics/{id}/book` | Booking reference created, slot reserved | Pass (Pest) |
| **TC-10** | Meet RSVP & coordinates | Host meet with lat/lng, toggle RSVP | `going_count` increments, coordinates saved | Pass (Pest) |
| **TC-11** | Live crew riding presence | `PUT /crews/live` & `GET /crews/live` | Active rider presence returned with coordinates | Pass (Pest) |
| **TC-12** | Feed likes & comments | `PUT /feed/{id}/like`, `POST /feed/{id}/comments` | Counts increment, comment persisted | Pass (Pest) |
| **TC-13** | Seller mobile API | Seller fetches dashboard, updates part, replies inquiry | `200 OK`; non-seller receives `403 Forbidden` | Pass (Pest) |
| **TC-14** | Admin vetting portal | Approve `SellerApplication` in `/admin` | Merchant role granted, application status updated | Pass (Pest) |
| **TC-15** | Security headers on web | Request `/login` | `X-Frame-Options: DENY`, `nosniff`, CSP present | Pass (Pest) |
| **TC-16** | Dashboard cache invalidation | Trigger `DomainStateChanged` event | Cached metrics cleared automatically | Pass (Pest) |
| **TC-17** | Flutter static analysis | Run `flutter analyze` | 0 errors, 0 warnings | Pass |
| **TC-18** | Live device UAT | End-to-end walkthrough on physical Android/iOS device | Full user acceptance sign-off | Pending (Planned) |

---

## 7.4 Observations and Defects Addressed

During iterative development and testing, the following key issues were identified and resolved:

*Table 23: Defects identified and addressed*

| # | Defect / Observation | Root Cause | Resolution |
| :--- | :--- | :--- | :--- |
| 1 | Potential tenant spoofing via HTTP headers | Early design considered `X-Tenant-ID` header | `ResolveTenantContextMiddleware` restricted to authenticated user / default `colombo-hq` |
| 2 | Unauthorized access to another user's vehicle | Missing object-level check on garage routes | Added `VehiclePolicy` (`view`, `update`) enforced in `GarageController` |
| 3 | Stale dashboard metrics after mutations | Cached overview did not refresh immediately | Added `DomainStateChanged` event + `InvalidateDashboardCacheListener` |
| 4 | Sri Lankan local mobile format mismatch | Users entering `077...` instead of `+9477...` | Added mobile normalization in `RegisterUserAction` & validation |
| 5 | Meet pins lacked real map coordinates | Initial meets used relative ratio pins only | Added migration `2026_11_22_164000_add_meet_coords_and_crew_live_presences.php` |
| 6 | Unused `AppRouter` (`GoRouter`) coexisting with `MainShell` | Starter template router retained alongside `ApexAppState` | Documented as architectural note; `MainShell` serves as active navigation root |

---

## 7.5 Test Summary

All **17 automated Pest tests (202 assertions)** passed in **630 ms**, and `flutter analyze` confirmed **0 errors and 0 warnings** across the Flutter codebase. External physical-device UAT and live cloud deployment verification remain as the final pre-release steps.

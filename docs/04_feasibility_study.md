# Chapter 4: Feasibility Study

A feasibility study evaluates whether the proposed project can be successfully delivered within the available time, budget, scope, technical capability, and economic constraints.

---

## 4.1 Time Feasibility

The project was structured over `[PROJECT_DURATION_WEEKS]` weeks with clear vertical milestones. High-risk architectural components—multi-tenancy isolation, Sanctum token authentication, `VehiclePolicy` authorization, and the 27-table relational schema—were completed early, allowing subsequent weeks to focus on Flutter UI integration, Seller Mode, and automated Pest test coverage. Because core development and automated verification finished within the planned window, the project proved **feasible in time**, with only live cloud deployment and formal external UAT deferred to post-submission.

---

## 4.2 Cost Feasibility

All development tools, frameworks, and local testing infrastructure used in ApexGarage SL rely on open-source software or free developer tiers, resulting in zero mandatory software licensing costs during development.

*Table 5: Cost assessment*

| Item | Option Used | Cost |
| :--- | :--- | :--- |
| Development IDEs & SDKs | Visual Studio Code, Android Studio / Xcode, Flutter SDK, PHP 8.3, Composer | Free (Open Source) |
| Backend Framework & Packages | Laravel 13, Sanctum, Fortify, Livewire 4, Spatie Permission, Pest | Free (MIT / Open Source) |
| Mobile Packages | `provider`, `dio`, `hive`, `go_router`, `image_picker`, `lucide_icons_flutter` | Free (Open Source) |
| Database (Dev & Test) | SQLite (`backend/database/database.sqlite`) | Free |
| Mapping Services | `google_maps_flutter` (Google Maps SDK free monthly credit tier) | Free within developer quota |
| Version Control & CI | Git / GitHub | Free |
| Hosting (Planned Production) | Cloud VPS / Laravel Forge + Managed MySQL/PostgreSQL + S3-compatible storage | Low monthly cost (pay-as-you-grow) |

Because every core tool is open-source and external services operate within free developer tiers during build and testing, the project is **cost-feasible**.

---

## 4.3 Scope Feasibility

The scope was carefully bounded so that a single developer could deliver a complete, verified end-to-end platform while leaving non-essential external integrations for future phases.

*Table 6: Project scope*

| In Scope | Out of Scope (Future Work) |
| :--- | :--- |
| Cross-platform Flutter app (Android & iOS) for Enthusiasts and Sellers | Native desktop or web-compiled Flutter builds |
| Digital Garage (vehicles, build logs, service glovebox, photo uploads) | OBD-II / hardware telematics dongle integration |
| Parts Marketplace (search, price histogram, save, reserve, buyer-seller chat) | Online credit/debit card payment gateway & escrow settlement |
| Workshop directory, slot availability, and bay booking | Automated workshop POS / accounting ERP |
| Interactive Colombo-centered meets map, RSVPs, crews, and live riding presence | Turn-by-turn voice navigation |
| Livewire Admin & Seller web portals (vetting, moderation, ads, metrics) | Live Dialog IdeaBiz carrier billing production credentials |
| Multi-tenancy (`colombo-hq` default) and Spatie RBAC | Automated multi-region billing & tax invoicing |

---

## 4.4 Technical Feasibility

The selected technology stack—**Flutter (Dart 3.3+)** for mobile and **Laravel 13 (PHP 8.3)** with **Livewire 4** for backend and web portals—is mature, well-documented, and supported by strong static analysis (`very_good_analysis`) and testing tools (`Pest`). Key technical risks were mitigated as follows:

- **API Security & Authorization:** Handled natively via Laravel Sanctum, `VehiclePolicy`, `ResolveTenantContextMiddleware`, `SecurityHeadersMiddleware`, and tiered `RateLimiter` rules.
- **Offline/Demo Resilience:** `ApexAppState` includes seed models (`kSeedVehicles`, `kSeedParts`, `kSeedMechanics`, `kSeedMeets`, `kSeedCrews`) so UI flows remain demonstrable even when the local API server is unreachable.
- **Mapping & Media:** `google_maps_flutter` and `image_picker` paired with `/api/v1/media/upload` (`MediaStorageInterface`) provide standard, reliable hardware and map integrations.

The project is therefore **technically feasible**.

---

## 4.5 Economic Feasibility

ApexGarage SL delivers clear economic value to all three user groups at minimal operating cost:

- **For Vehicle Owners:** Documented build logs and verified service histories protect vehicle resale value and reduce unexpected maintenance costs by tracking service intervals.
- **For Parts Sellers & Workshops:** Verified merchant status, structured fitment listings, and bay slot scheduling increase customer trust, reduce no-shows, and lower customer acquisition costs compared to scattered social media posts.
- **For Platform Operators:** Revenue pathways are built directly into the architecture through `sponsored_ads` (tracking impressions, clicks, CTR, and LKR revenue) and `subscriptions` (Pro membership tiers).

The low infrastructure footprint combined with clear monetization and user-value drivers makes the platform **economically feasible**.

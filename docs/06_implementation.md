# Chapter 6: Implementation

This chapter documents how the ApexGarage SL design was implemented across the Laravel backend, the Flutter mobile client, the Livewire web portals, and each functional module.

---

## 6.1 Backend Architecture & Security

The backend (`backend/`) is a Laravel 13 application structured around **10 domain modules** under `backend/app/Domains/`, paired with service contracts in `backend/app/Contracts/`. Requests enter through `routes/api.php` (stateless `/api/v1/*`) or `routes/web.php` (session-backed Livewire portals), pass through middleware (`ResolveTenantContextMiddleware`, `SecurityHeadersMiddleware`, `RateLimiter`), validate via `FormRequest` classes, and execute single-purpose **Action** classes.

*Table 14: Backend REST API endpoints (`/api/v1`)*

| Method | Route (`/api/v1/...`) | Purpose | Access |
| :--- | :--- | :--- | :--- |
| `POST` | `auth/login`, `auth/register` | Authenticate or register (with `+94` normalization) | Public (`throttle:auth` / `register`) |
| `POST / GET` | `auth/logout`, `auth/me` | Revoke Sanctum token; fetch current user | Authenticated |
| `GET / PATCH` | `user/profile`, `user/onboarding`, `user/active-vehicle` | Profile summary, onboarding cultures, active vehicle | Authenticated |
| `GET` | `home` | Active vehicle, next meet, promotion, sponsored ads, feed | Authenticated |
| `GET / POST` | `vehicles`, `vehicles/{vehicle}` | List/create vehicles; view vehicle (`VehiclePolicy`) | Authenticated |
| `POST` | `vehicles/{vehicle}/build-logs`, `.../service-records` | Add build log or service glovebox entry | Authenticated (Owner) |
| `POST` | `media/upload` | Upload image to `vehicles`, `builds`, or `parts` | Authenticated (`throttle:uploads`) |
| `GET` | `marketplace/parts`, `.../histogram`, `.../{part}` | Browse/search parts, price histogram, part detail | Public |
| `POST / PUT` | `marketplace/parts`, `.../{part}/save`, `.../{part}/reserve` | Publish, save/unsave, or reserve part | Authenticated |
| `GET / POST` | `marketplace/parts/{part}/chat` | Read and send buyer-seller chat messages | Authenticated (`throttle:chat`) |
| `GET / POST` | `mechanics`, `mechanics/{workshop}/slots`, `.../book` | List workshops, view slots, book service bay | Public (GET) / Auth (POST) |
| `GET / POST / PUT` | `meets`, `meets/{meet}/rsvp` | List meets, host meet (`5/hr`), toggle RSVP | Public (GET) / Auth (Write) |
| `GET / POST / PUT` | `crews`, `crews/{crew}/membership`, `crews/live` | List/create crews, join/leave, live riding presence | Public (GET) / Auth (Write) |
| `GET / PUT / POST` | `feed`, `feed/{post}/like`, `feed/{post}/comments` | Community feed, likes, and comments | Public (GET) / Auth (Write) |
| `GET` | `promotions/active` | Active partner promotion (e.g., Motul offer) | Public |
| `GET / POST / PATCH` | `seller/dashboard`, `seller/parts/{part}`, `seller/inquiries/{inquiry}/reply`, `seller/bookings/{booking}`, `seller/profile` | Mobile Seller Mode operations | Authenticated (`workshop-partner`) |

### Security Controls
- **Authentication & Passwords:** Passwords are stored using BCrypt; Sanctum issues scoped personal access tokens. Web portals use Laravel Fortify with Two-Factor Authentication (`two_factor_secret`) and Passkey support (`passkeys` table).
- **Authorization & IDOR Prevention:** `VehiclePolicy` ensures only the vehicle owner can view or mutate a vehicle's build logs and service records. Spatie RBAC gates `/admin` (`role:super-admin`) and `/seller` (`role:workshop-partner`).
- **Tenant Isolation:** `ResolveTenantContextMiddleware` resolves the tenant strictly from the authenticated user or default `colombo-hq` tenant—client `X-Tenant-ID` headers are ignored.
- **HTTP Security Headers:** `SecurityHeadersMiddleware` applies `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, `Strict-Transport-Security`, and `Content-Security-Policy`.

*Table 15: Role and permission matrix*

| Capability / Area | Enthusiast | Workshop Partner (`workshop-partner`) | Super Admin (`super-admin`) |
| :--- | :---: | :---: | :---: |
| Garage, Builds, Service Glovebox | ✓ | ✓ | ✓ |
| Marketplace Browse, Chat & Reserve | ✓ | ✓ | ✓ |
| Meets, Crews & Live Riding Presence | ✓ | ✓ | ✓ |
| Mobile Seller Mode & `/seller` Portal | — | ✓ | ✓ |
| `/admin` Vetting, Moderation & Ads | — | — | ✓ |

---

## 6.2 Mobile Frontend (Flutter) & Web Portals (Livewire)

### Flutter Mobile Client (`lib/`)
The Flutter application (`apexgarage_sl`) initializes via `lib/bootstrap.dart` (`Hive.initFlutter()`, `TokenStorage.init()`, `GetIt` registrations) and mounts `MainShell` inside `StarterApp` (`lib/app/view/app.dart`). `ApexAppState` (`ChangeNotifier`) coordinates API calls through `ApiRepository` (`lib/core/services/api_repository.dart`) and `ApiClient` (`Dio` + `AuthInterceptor`). When `AuthInterceptor` receives HTTP `401`, it clears the Hive-stored token (`apex_auth_box`).

*Table 16: Flutter mobile screens & Seller Mode views*

| Screen / View | File Path | Purpose |
| :--- | :--- | :--- |
| `SplashScreen` | `lib/features/onboarding/view/splash_screen.dart` | Animated rotor logo startup & session restore |
| `AuthScreen` | `lib/features/onboarding/view/auth_screen.dart` | Sign In / Sign Up with SL mobile or email |
| `OnboardingCarousel` | `lib/features/onboarding/view/onboarding_carousel.dart` | Select automotive cultures (`JDM`, `Euro`, etc.) |
| `HomeView` | `lib/features/home/view/home_view.dart` | Active vehicle header, next meet, promo, ads, feed |
| `GarageView` & `VehicleDetailView` | `lib/features/garage/view/` | Fleet list (`All/Cars/Bikes`), Build Showcase, Service Glovebox |
| `MarketplaceView` & `PartDetailView` | `lib/features/marketplace/view/` | Parts search, `HistogramFilterSheet`, save, reserve, `SellerChatSheet` |
| `MechanicsView` & `ServiceBookingSheet` | `lib/features/mechanics/view/` | Verified workshops & bay slot booking |
| `MeetsView` & `InteractiveMapView` | `lib/features/meets/view/` | Meets list, `GoogleMap` pins, crews, live riding toggle |
| `ProfileView` & `IdeaBizBillingSheet` | `lib/features/billing/view/` | User stats, sign out, IdeaBiz PRO UI |
| `SellerShell` (5 tabs) | `lib/features/seller/view/seller_shell.dart` | Dashboard, Inventory, Inquiries, Workshop Bookings, Shop Profile |

### Livewire 4 Web Portals (`backend/app/Livewire/`)
*Table 17: Livewire web portals & routes*

| Route | Component | Access | Purpose |
| :--- | :--- | :--- | :--- |
| `/login` | `App\Livewire\Auth\LoginGate` | Public | Web login & merchant registration (`SellerApplication`) |
| `/admin` | `App\Livewire\Admin\AdminPortal` | `super-admin` | Vet seller applications, moderate part listings, manage sponsored ads |
| `/seller` | `App\Livewire\Seller\SellerPortal` | `workshop-partner` | Publish/edit parts, reply to buyer inquiries, manage bay bookings |

---

## 6.3 Multi-Tenancy, Caching & Background Jobs

- **Multi-Tenancy (`backend/app/Domains/Tenancy/`):** Models using the `BelongsToTenant` trait automatically attach `TenantScope`, ensuring queries only return records matching the active `TenantContext` (`colombo-hq` by default).
- **Dashboard Caching (`backend/app/Domains/Dashboard/`):** `CachedDashboardMetricsService` caches overview metrics; whenever a domain action mutates state, it dispatches `DomainStateChanged`, triggering `InvalidateDashboardCacheListener` to clear stale cache entries.
- **Asynchronous Jobs:** `ProcessServiceReceiptOcrJob` handles queued receipt processing for service records, and `SyncIdeaBizSubscriptionJob` handles asynchronous carrier subscription synchronization.

---

## 6.4 Modules

- **Auth & Onboarding:** Supports Sri Lankan local mobile numbers (auto-normalized from `077...` to `+9477...`), email login, Sanctum token persistence in Hive, and culture-based onboarding.
- **Home & Community Feed:** Displays the user's active vehicle, upcoming meet preview, active Motul/partner promotion, dynamic `sponsored_ads`, and a community build feed with real-time like toggles and comments.
- **Digital Garage & Service Glovebox:** Lets owners add vehicles with photos (`image_picker` -> `/api/v1/media/upload`), record modification build logs (optionally cross-posted to the feed), and log odometer-stamped service records with parts changed and next-service alerts.
- **Marketplace & Seller Chat:** Combines keyword search, brand/condition filters, and a `HistogramSlider` price-distribution filter. Buyers can save parts, chat with sellers in per-listing `BuyerInquiry` threads, and reserve stock.
- **Workshops & Mechanics:** Lists verified workshops with ratings, specialties, and base LKR pricing; users inspect available bay slots and confirm bookings.
- **Meets & Live Crew Map:** Renders `GoogleMap` centered on Colombo (`6.9271, 79.8612`) with meet pins and live crew rider markers (`crew_live_presences`), plus sheets to host meets and create/join crews.
- **Seller Mode & Admin Vetting:** Merchants apply via `SellerApplication`, are vetted in `/admin`, and manage their storefront, parts, inquiries, and bay bookings from either the `/seller` web portal or the mobile `SellerShell`.

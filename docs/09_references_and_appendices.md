# References & Appendices

## References

- Akerlof, G.A. (1970) ‘The Market for “Lemons”: Quality Uncertainty and the Market Mechanism’, *The Quarterly Journal of Economics*, 84(3), pp. 488–500.
- Evans, E. (2003) *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Boston: Addison-Wesley.
- Fowler, M. (2002) *Patterns of Enterprise Application Architecture*. Boston: Addison-Wesley.
- Google (2026) *Flutter Documentation*. Available at: https://docs.flutter.dev/ (Accessed: `[ACCESS_DATE]`).
- Google (2026) *Google Maps Platform — Maps SDK for Android & iOS*. Available at: https://developers.google.com/maps (Accessed: `[ACCESS_DATE]`).
- Laravel (2026) *Laravel 13 Documentation — Sanctum, Fortify & Queues*. Available at: https://laravel.com/docs (Accessed: `[ACCESS_DATE]`).
- Livewire (2026) *Livewire 4 Documentation*. Available at: https://livewire.laravel.com/docs (Accessed: `[ACCESS_DATE]`).
- OWASP (2023) *OWASP API Security Top 10*. Available at: https://owasp.org/API-Security/ (Accessed: `[ACCESS_DATE]`).
- Pest (2026) *Pest PHP Testing Framework*. Available at: https://pestphp.com/docs (Accessed: `[ACCESS_DATE]`).
- Spatie (2026) *Laravel Permission Documentation*. Available at: https://spatie.be/docs/laravel-permission (Accessed: `[ACCESS_DATE]`).

---

## Appendix A: Interim Progress Reports

`[Attach or paste your submitted Interim Progress Report(s) here as required by CS6P05ES.]`

---

## Appendix B: Progress Approval Form & Project Commencement Meeting Sheet

`[Attach your signed Progress Approval Form and Project Commencement Meeting Sheet here as required by CS6P05ES.]`

---

## Appendix C: Company Letter

`[Attach Company Letter here if your project was conducted with an external organization, or state "Not Applicable".]`

---

## Appendix D: Running the System and Demo Accounts

### 1. Backend Setup (`backend/`)
1. Navigate to `backend/` and install PHP dependencies:
   ```bash
   cd backend
   composer install
   cp .env.example .env
   php artisan key:generate
   ```
2. Run database migrations and seed demo data (`colombo-hq` tenant, RBAC roles, demo users, vehicles, parts, workshops, meets, and crews):
   ```bash
   php artisan migrate --seed
   ```
3. Start the local API and Livewire server:
   ```bash
   php artisan serve --host=0.0.0.0 --port=8000
   ```
4. Run the automated Pest test suite:
   ```bash
   php artisan test
   ```

### 2. Flutter Mobile App Setup (Root Directory)
1. Install Dart/Flutter packages:
   ```bash
   flutter pub get
   ```
2. Run static analysis:
   ```bash
   flutter analyze
   ```
3. Launch the development entrypoint (pointing `APEX_API_URL` to your local backend if needed):
   ```bash
   flutter run -t lib/main_development.dart --dart-define=APEX_API_URL=http://127.0.0.1:8000
   ```

### 3. Seeded Demo Accounts (`DatabaseSeeder.php`)

*Table 27: Seeded demo accounts (change passwords before any production deployment)*

| Role | Email | Notes |
| :--- | :--- | :--- |
| **Super Admin (`super-admin`)** | `admin@apexgarage.lk` | Accesses `/admin` Livewire vetting & moderation portal |
| **Enthusiast** | `dineth@apexgarage.lk` | Seeded enthusiast with vehicles (`Civic Type R FD2`, etc.) |
| **Workshop Partner (`workshop-partner`)** | `sales@jdmdirect.lk` | Accesses mobile Seller Mode & `/seller` portal |
| **Workshop Partner (`workshop-partner`)** | `moto@hillcountry.lk` | Accesses mobile Seller Mode & `/seller` portal |
| **Workshop Partner (`workshop-partner`)** | `parts@boostyard.lk` | Accesses mobile Seller Mode & `/seller` portal |

*(Refer to `backend/database/seeders/DatabaseSeeder.php` for seeded credentials.)*

---

## Appendix E: Key Database Migrations Reference

- `0001_01_01_000000_create_users_table.php` — Core users, sessions, password resets
- `2026_11_15_135720_create_permission_tables.php` — Spatie RBAC roles & permissions
- `2026_11_15_135721_create_personal_access_tokens_table.php` — Sanctum API tokens
- `2026_11_15_135721_add_two_factor_columns_to_users_table.php` — Fortify 2FA columns
- `2026_11_15_135722_create_passkeys_table.php` — WebAuthn/Passkey credentials
- `2026_11_15_140000_create_apexgarage_domain_tables.php` — Tenants, vehicles, build logs, service records, part listings, workshops, meets, crews, community posts, promotions, subscriptions
- `2026_11_15_150000_create_admin_seller_portal_tables.php` — Seller applications, buyer inquiries, inquiry messages, workshop bookings, sponsored ads
- `2026_11_15_160000_link_portal_records_to_users.php` — Foreign keys linking portal records to users
- `2026_11_15_170000_mobile_api_foundation.php` — Saved parts, meet RSVPs, crew members, post likes, onboarding fields
- `2026_11_22_143000_add_photo_url_to_community_posts_and_build_logs.php` — Media photo URLs
- `2026_11_22_150000_add_comments_and_vehicle_part_photos.php` — Post comments & vehicle/part photo URLs
- `2026_11_22_164000_add_meet_coords_and_crew_live_presences.php` — Meet lat/lng coordinates & live crew riding presence

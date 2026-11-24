# Chapter 1: Introduction

This chapter presents an overview of the **ApexGarage SL** project. It outlines the project goals, the motivation behind building a localized automotive ecosystem for Sri Lanka, the iterative development methodology adopted, and the overall scope and structure of this report.

---

## 1.1 Goals

The primary goal of this project was to design, develop, and verify a secure, multi-tenant mobile and web platform tailored for Sri Lankan automotive enthusiasts, vehicle owners, and aftermarket workshops. The specific objectives were:

1. **Research the automotive ecosystem:** Study the challenges faced by Sri Lankan car and motorcycle enthusiasts, parts sellers, and independent workshops, as well as the limitations of existing fragmented platforms.
2. **Select a scalable technology stack:** Choose a cross-platform mobile framework (Flutter) paired with a domain-driven backend API and web portal stack (Laravel 13, Sanctum, Livewire 4, Spatie RBAC).
3. **Build a digital garage and service glovebox:** Enable vehicle owners to catalog their fleet, document modification build logs with photos, and maintain verifiable service records with odometer and next-service tracking.
4. **Implement a verified marketplace and workshop booking system:** Provide a parts marketplace with price-histogram filtering, direct buyer-seller chat, part reservations, and workshop bay slot booking.
5. **Deliver community meets and live crew tracking:** Build an interactive map and community feed where enthusiasts can share builds, RSVP to meets, join crews, and toggle live riding presence.
6. **Provide role-based seller and admin portals:** Implement a mobile Seller Mode and web-based Livewire portals for merchant vetting, listing moderation, inquiry management, and platform analytics, and verify the system through automated testing and static analysis.

---

## 1.2 Motivation

Sri Lanka has a vibrant automotive and motorcycle enthusiast community spanning JDM imports, European performance builds, off-road 4x4s, and sportbikes. However, the tools used by this community remain highly fragmented and informal:

- **Paper-based maintenance:** Vehicle service histories and modification receipts are typically stored as loose paper invoices, making it difficult to prove provenance or track service intervals when reselling a vehicle.
- **Unverified parts trading:** Performance and OEM spare parts are predominantly bought and sold through general classifieds or social media groups without structured fitment metadata, price distribution visibility, or verified merchant vetting.
- **Manual workshop scheduling:** Independent garages and tuning shops rely on phone calls and messaging apps to schedule service bays, leading to double-bookings and poor visibility into available time slots.
- **Disconnected community coordination:** Car meets, night runs, and crew rides are organized across separate messaging chats with no centralized map, RSVP tracking, or live crew presence.

By consolidating these workflows into **ApexGarage SL**, enthusiasts gain a single digital home for their vehicles, while local workshops and parts merchants gain a vetted, structured channel to reach customers and manage bookings.

---

## 1.3 Method

The project followed an **iterative, phase-based development methodology** with a continuous fix-and-retest loop. Work was structured into seven core phases:

1. **Requirements & Domain Research:** Identifying user roles, functional/non-functional requirements, and Sri Lankan localization needs (LKR currency, `+94` mobile normalization, Colombo-centered mapping).
2. **Architecture & Database Design:** Designing the domain-driven Laravel backend, 27-table relational schema, multi-tenancy isolation, and Flutter state architecture.
3. **Backend API & Portal Implementation:** Building Laravel 13 domain actions, Sanctum REST endpoints (`/api/v1`), `VehiclePolicy` authorization, and Livewire 4 web portals (`/admin`, `/seller`).
4. **Flutter Mobile App Implementation:** Developing the enthusiast 5-tab shell, Seller Mode shell, Google Maps integration, image upload flows, and Hive-backed token persistence.
5. **Integration & Feature Wiring:** Connecting all Flutter screens to live Laravel endpoints via `ApiRepository` and `Dio`, including fallback seed models for offline preview.
6. **Testing & Static Analysis:** Writing and running automated Pest feature/unit tests (`php artisan test`) and Flutter static analysis (`flutter analyze`), fixing defects iteratively.
7. **Deployment Preparation & Documentation:** Preparing environment configurations, database seeders, and compiling this final project report.

---

## 1.4 Overview

**ApexGarage SL** operates in the domain of automotive lifestyle, e-commerce, and workshop management software. It comprises:

- **Mobile Client:** A Flutter application (`apexgarage_sl`) supporting iOS and Android, using `Provider` (`ApexAppState`), `Dio` with `AuthInterceptor`, `Hive` for local session persistence, `google_maps_flutter` for meet and crew mapping, and `image_picker` for vehicle, build, and part photography.
- **Backend API & Web Portals:** A Laravel 13 PHP 8.3 application organized into 10 domain modules (`Auth`, `Tenancy`, `Garage`, `Marketplace`, `Workshops`, `Community`, `Advertising`, `Vetting`, `Subscriptions`, `Dashboard`), exposing `/api/v1/*` REST endpoints via Laravel Sanctum and `/admin` and `/seller` web portals via Livewire 4.
- **Data Layer:** A relational SQL database (SQLite in local development/testing, compatible with PostgreSQL/MySQL in production) managed via Laravel migrations and Eloquent ORM.

**Scope.** The current implementation covers full end-to-end flows for Enthusiasts, Workshop Partners/Sellers, and Super Administrators in Sri Lanka (LKR pricing, `+94` phone validation, Colombo-centered map coordinates). Live carrier billing via Dialog IdeaBiz and automated OCR receipt extraction are architected via service interfaces (`TelcoBillingGatewayInterface`, `ProcessServiceReceiptOcrJob`) and simulated/queued for future production activation.

The remainder of this report is organized as follows: **Chapter 2** reviews the background, literature, and problem statement. **Chapter 3** details project management, plans, and changes. **Chapter 4** presents the feasibility study. **Chapter 5** covers system design, diagrams, and requirements. **Chapter 6** explains the implementation of backend, mobile, and web modules. **Chapter 7** presents the test plan, automated test results, and defects addressed. **Chapter 8** evaluates the project against its objectives, discusses limitations and future work, and concludes.

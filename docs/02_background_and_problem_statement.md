# Chapter 2: Background and Problem Statement

This chapter examines the automotive aftermarket and enthusiast domain, reviews relevant literature and existing software platforms, identifies the research and market gap, and defines the problem statement addressed by ApexGarage SL.

---

## 2.1 Introduction

Digitalization in the automotive sector has traditionally focused on new-vehicle telematics, manufacturer-authorized service centers, and generic classifieds websites. In emerging markets such as Sri Lanka, however, the secondary vehicle market and aftermarket modification culture represent a large share of automotive spending. Vehicles are owned longer, modified across multiple specialist workshops, and traded peer-to-peer. When maintenance records, part provenance, and workshop reputations are undocumented, both buyers and sellers face high information asymmetry.

At the same time, automotive enthusiasm is inherently social. Car and motorcycle clubs rely on shared visual build logs, trusted mechanic recommendations, and coordinated group drives. A platform that unifies **vehicle lifecycle records**, **vetted commerce**, **service scheduling**, and **community engagement** addresses both practical ownership pain points and social engagement.

---

## 2.2 Literature Review

### 2.2.1 Digital Vehicle Maintenance & Provenance Systems
Maintaining accurate, tamper-resistant vehicle service histories reduces information asymmetry in used-vehicle markets (Akerlof, 1970). Digital glovebox applications allow owners to log odometer readings, parts replaced, and workshop invoices chronologically. When linked to specific vehicle chassis/VIN identifiers and verified workshops, digital logs increase buyer confidence and resale value compared to paper receipts.

### 2.2.2 Vertical Marketplaces vs. Horizontal Classifieds
Horizontal classified platforms (such as general-purpose buy-and-sell sites) optimize for broad listing volume rather than domain-specific trust. In contrast, vertical automotive marketplaces improve buyer conversion by enforcing structured fitment metadata (chassis code, condition, SKU), price-distribution visibility (histograms), and seller verification (vetting business registration details before granting merchant status). Direct in-app inquiry threads further reduce friction compared to redirecting users to external messaging apps.

### 2.2.3 Multi-Tenant SaaS & Domain-Driven Architecture
Modern SaaS platforms serving multiple regional hubs or partner networks benefit from multi-tenancy with strict data isolation (Fowler, 2002). Implementing a shared-database, tenant-scoped architecture using global query scopes (`TenantScope`) and server-side tenant resolution ensures that client requests cannot spoof tenant boundaries via forged HTTP headers. Organizing backend logic into bounded domain modules (`Garage`, `Marketplace`, `Workshops`, `Community`, `Vetting`) using single-responsibility Action classes and DTOs improves maintainability and testability (Evans, 2003).

### 2.2.4 Role-Based Access Control (RBAC) & Mobile API Security
Mobile applications communicating over REST APIs require stateless bearer-token authentication (such as Laravel Sanctum), strict object-level authorization policies to prevent Insecure Direct Object References (IDOR), and tiered rate limiting to mitigate brute-force and credential-stuffing attacks (OWASP, 2023). Separating public discovery endpoints from authenticated write endpoints and restricting administrative actions via explicit RBAC permissions (`spatie/laravel-permission`) enforces least-privilege access.

### 2.2.5 Community Mapping & Real-Time Presence
Location-based community features—such as interactive meet maps and live crew riding indicators—strengthen user retention in niche hobbyist networks. Using standard coordinate mapping (`google_maps_flutter`) paired with lightweight opt-in presence records (`crew_live_presences` with last-seen timestamps) allows riders and drivers to coordinate group runs without requiring continuous high-bandwidth GPS streaming.

### 2.2.6 Comparison with Existing Systems

Table 1 compares existing platform categories available to Sri Lankan automotive users against ApexGarage SL.

*Table 1: Comparison of existing system types with ApexGarage SL*

| System Type | Digital Garage & Build Logs | Verified Parts Marketplace | Workshop Bay Booking | Community Meets & Live Crew Map | Local SL Context (LKR / +94) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **General Classifieds** (e.g., ikman.lk) | No | Partial (unstructured) | No | No | Yes |
| **Social Media Groups** (Facebook / WhatsApp) | Informal posts only | Unverified, no escrow/chat tracking | No | Informal chat messages | Yes |
| **Global Garage Apps** (e.g., Fuelly, Carfax) | Basic maintenance only | No | No | No | No (USD/US focus) |
| **Standalone Booking Tools** | No | No | Yes | No | Rarely |
| **ApexGarage SL** | **Yes (Builds + Service Glovebox)** | **Yes (Vetted sellers, histogram, chat, reserve)** | **Yes (Slot availability & booking)** | **Yes (Meets map, RSVPs, Crews, Live presence)** | **Yes (LKR, +94, Colombo map)** |

### 2.2.7 Research Gap
Existing tools solve at most one fragment of the automotive ownership lifecycle: classifieds handle ad-hoc listings without fitment or vetting; social media hosts informal discussions without structured history; and global maintenance trackers lack local Sri Lankan parts commerce, workshop scheduling, and community meet coordination. Very few platforms integrate **multi-role workflows** (Enthusiast, Workshop Partner, Super Admin) with **tenant-isolated domain APIs** and **localized Sri Lankan conventions** in a single mobile-first ecosystem.

---

## 2.3 Problem Statement

The key problems addressed by this project are:

- **Fragmented Vehicle Records:** Sri Lankan vehicle owners lack a centralized digital system to track modification builds, odometer milestones, and verified service histories.
- **Low Trust in Aftermarket Parts Trading:** Buyers cannot easily verify seller legitimacy, compare part pricing distributions, or track inquiries and reservations in one place.
- **Inefficient Workshop Scheduling:** Independent garages lack an integrated digital bay-booking and status-management workflow connected directly to customer vehicles.
- **Scattered Community Coordination:** Enthusiast meets, club memberships, and group rides lack a dedicated map-based coordination tool.
- **Lack of Unified Merchant & Admin Governance:** Platform operators need a vetting workflow to approve workshop partners, moderate listings, and monitor platform-wide metrics securely.

**ApexGarage SL** solves these problems by delivering a unified Flutter mobile application and Laravel 13 backend with role-based web portals, combining garage management, vetted marketplace commerce, workshop booking, and live community mapping under a secure, multi-tenant architecture.

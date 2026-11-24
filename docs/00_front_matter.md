# ApexGarage SL — Digital Garage & Automotive Performance Platform

**Final Project Report**

- **Module:** CS6P05ES
- **Module Leader:** `[MODULE_LEADER]`
- **Name:** `[STUDENT_FULL_NAME]`
- **London Met ID No:** `[LONDON_MET_ID]`
- **University / Campus:** London Metropolitan University (`[CAMPUS_NAME]`)
- **Degree Programme:** `[DEGREE_PROGRAMME_TITLE]`
- **Supervisors:** `[SUPERVISOR_1_NAME]`, `[SUPERVISOR_2_NAME]`
- **Deadline / Submission Date:** `[DEADLINE_DATE]`

---

## Declaration

- **Module:** CS6P05ES &nbsp;&nbsp;&nbsp;&nbsp; **Deadline:** `[DEADLINE_DATE]`
- **Module Leader:** `[MODULE_LEADER]` &nbsp;&nbsp;&nbsp;&nbsp; **Student ID:** `[LONDON_MET_ID]`

I declare that this report and the software it describes are my own work, except where the work of others is acknowledged and referenced. I have read and understood the regulations concerning plagiarism, cheating, and collusion as set out in Section 2.3 of the University Regulations.

**Signature:** ______________________ &nbsp;&nbsp;&nbsp;&nbsp; **Date:** ______________

---

## Dedication

This project is dedicated to my parents and family, whose unwavering love, patience, and encouragement have been my greatest source of strength throughout this degree. I also dedicate this work to my friends and fellow automotive enthusiasts who inspired the vision behind ApexGarage SL and motivated me to see this project through to completion.

---

## Acknowledgements

I would like to express my sincere gratitude to my supervisors `[SUPERVISOR_1_NAME]` and `[SUPERVISOR_2_NAME]` for their guidance, constructive feedback, and patience throughout this project. I also thank the lecturers and staff at `[UNIVERSITY_AND_CAMPUS_NAME]` for their academic support, as well as the automotive enthusiasts, workshop owners, and peers who provided domain insights and tested the platform. Finally, I am deeply grateful to my family and friends for their encouragement and support.

---

## Abstract

Automotive enthusiasts, vehicle owners, and independent aftermarket workshops in Sri Lanka lack a unified digital platform to manage vehicle build histories, verify service records, source authentic performance parts, and coordinate community meets. Currently, vehicle maintenance logs are kept on paper, performance parts are traded informally across unverified social media groups, and workshop appointments rely on manual phone calls. The goal of this project was to design, implement, and verify ApexGarage SL, a secure, multi-tenant mobile and web platform that consolidates digital garage management, an automotive parts marketplace, workshop bay booking, and live community meet coordination into a single cohesive ecosystem.

The platform supports four primary user roles: Enthusiasts, Workshop Partners, Super Administrators, and Background Queue Workers. Through the cross-platform Flutter mobile application, enthusiasts can register vehicles, log modification build histories and service glovebox records with receipt uploads, browse and filter performance parts using a price distribution histogram, chat directly with verified sellers, book workshop service bays, and confirm attendance at automotive meets or share live riding locations with their crew on an interactive map. Workshop Partners and Super Administrators are supported through both a dedicated mobile Seller Mode and web-based Livewire portals for merchant vetting, inventory management, inquiry replies, booking approvals, sponsored advertisement management, and platform analytics.

The system was designed using a domain-driven, multi-tier architecture consisting of a Flutter mobile client, a Laravel REST application programming interface secured with Sanctum bearer tokens and role-based access control, Livewire administrative and seller web portals, and a relational database with twenty-seven domain tables scoped by tenant isolation. Security controls include password hashing, two-factor authentication, passkey support, strict vehicle ownership policies, tiered rate limiting, and server-side security headers.

Verification was conducted using automated Pest feature and unit tests alongside Flutter static analysis. All seventeen automated backend tests comprising two hundred and two assertions passed in six hundred and thirty milliseconds, while static analysis confirmed zero errors and zero warnings across the mobile codebase. In conclusion, the project demonstrates that a unified, localized automotive platform can successfully replace fragmented manual workflows with a secure, scalable, and verifiable digital ecosystem.

---

## Table of Contents

- [Declaration](#declaration)
- [Dedication](#dedication)
- [Acknowledgements](#acknowledgements)
- [Abstract](#abstract)
- [Table of Figures](#table-of-figures)
- [Table of Tables](#table-of-tables)
- [Abbreviations](#abbreviations)
- [Chapter 1: Introduction](01_introduction.md)
  - 1.1 Goals
  - 1.2 Motivation
  - 1.3 Method
  - 1.4 Overview
- [Chapter 2: Background and Problem Statement](02_background_and_problem_statement.md)
  - 2.1 Introduction
  - 2.2 Literature Review
  - 2.3 Problem Statement
- [Chapter 3: Project Management](03_project_management.md)
  - 3.1 Approach
  - 3.2 Initial Project Plan
  - 3.3 Problems and Changes to the Plan
  - 3.4 Final Project Record
- [Chapter 4: Feasibility Study](04_feasibility_study.md)
  - 4.1 Time Feasibility
  - 4.2 Cost Feasibility
  - 4.3 Scope Feasibility
  - 4.4 Technical Feasibility
  - 4.5 Economic Feasibility
- [Chapter 5: Design](05_design.md)
  - 5.1 Proposed System
  - 5.2 Hardware and Software Requirements
  - 5.3 Evaluation of Solutions
- [Chapter 6: Implementation](06_implementation.md)
  - 6.1 Backend Architecture & Security
  - 6.2 Mobile Frontend (Flutter) & Web Portals (Livewire)
  - 6.3 Multi-Tenancy, Caching & Background Jobs
  - 6.4 Modules
- [Chapter 7: Testing and Verification](07_testing_and_verification.md)
  - 7.1 Test Plan
  - 7.2 Automated Backend Tests & Static Analysis
  - 7.3 System Test Cases
  - 7.4 Observations and Defects Addressed
  - 7.5 Test Summary
- [Chapter 8: Evaluation and Conclusion](08_evaluation_and_conclusion.md)
  - 8.1 Evaluation Against Objectives
  - 8.2 Critical Evaluation
  - 8.3 Limitations
  - 8.4 Future Plans
  - 8.5 Conclusion
- [References & Appendices](09_references_and_appendices.md)
  - References
  - Appendix A: Interim Progress Reports
  - Appendix B: Progress Approval Form & Project Commencement Meeting Sheet
  - Appendix C: Company Letter
  - Appendix D: Running the System and Demo Accounts
  - Appendix E: Key Database Migrations Reference

---

## Table of Figures

- Figure 1: Iterative Development Methodology with Fix-and-Retest Loop (Chapter 3)
- Figure 2: Initial Project Plan — Gantt Chart (Chapter 3)
- Figure 3: Final Project Record — Gantt Chart (Chapter 3)
- Figure 4: System Architecture — Flutter Client, Laravel API, Livewire Portals & Data Tier (Chapter 5)
- Figure 5: Use Case Diagram — Enthusiast, Workshop Partner, Super Admin & Queue Worker (Chapter 5)
- Figure 6: Conceptual Entity-Relationship Diagram (Chapter 5)
- Figure 7: Logical Entity-Relationship Diagram — Core Domains (Chapter 5)
- Figure 8: Sequence Diagram — Authenticated Garage & Marketplace Flow (Chapter 5)
- Figure 9: Class / Domain Architecture Diagram — Laravel Domains & Actions (Chapter 5)
- Figure 10: Deployment Diagram — Planned Production Architecture (Chapter 5)

---

## Table of Tables

- Table 1: Comparison of Existing Automotive Platforms with ApexGarage SL (Chapter 2)
- Table 2: Tasks in the Initial Project Plan (Chapter 3)
- Table 3: Problems Encountered and Changes to the Plan (Chapter 3)
- Table 4: Progress Against Interim Milestones (Chapter 3)
- Table 5: Cost Feasibility Assessment (Chapter 4)
- Table 6: Project Scope — In Scope vs. Out of Scope (Chapter 4)
- Table 7: Stakeholders and System Roles (Chapter 5)
- Table 8: Use Case Description — Publish Part Listing & Buyer Inquiry Chat (Chapter 5)
- Table 9: Functional Requirements (FR-01 to FR-22) (Chapter 5)
- Table 10: Non-Functional Requirements (NFR-01 to NFR-10) (Chapter 5)
- Table 11: Hardware Requirements (Chapter 5)
- Table 12: Software Requirements (Chapter 5)
- Table 13: Technology Alternatives Considered (Chapter 5)
- Table 14: Backend REST API Endpoints (`/api/v1`) (Chapter 6)
- Table 15: Role and Permission Matrix (Chapter 6)
- Table 16: Flutter Mobile Screens & Seller Mode Views (Chapter 6)
- Table 17: Livewire Web Portals & Routes (Chapter 6)
- Table 18: Test Plan Overview (Chapter 7)
- Table 19: Test Strategy & Tooling (Chapter 7)
- Table 20: Automated Backend Test Suites (Pest) (Chapter 7)
- Table 21: Static Analysis Summary (`flutter analyze`) (Chapter 7)
- Table 22: System Test Cases (TC-01 to TC-28) (Chapter 7)
- Table 23: Defects Identified and Addressed (Chapter 7)
- Table 24: Evaluation Against Project Objectives (Chapter 8)
- Table 25: Future System Improvements (Chapter 8)
- Table 26: Research and Feature Extensions (Chapter 8)
- Table 27: Seeded Demo Accounts (Appendix A)

---

## Abbreviations

| Abbreviation | Full Form |
| :--- | :--- |
| **API** | Application Programming Interface |
| **BR** | Business Registration (Sri Lanka) |
| **CRUD** | Create, Read, Update, Delete |
| **CSP** | Content Security Policy |
| **CTR** | Click-Through Rate |
| **DTO** | Data Transfer Object |
| **ERD** | Entity-Relationship Diagram |
| **FK** | Foreign Key |
| **FR** | Functional Requirement |
| **GPS** | Global Positioning System |
| **HSTS** | HTTP Strict Transport Security |
| **HTTP / HTTPS** | Hypertext Transfer Protocol / Secure |
| **IDOR** | Insecure Direct Object Reference |
| **JSON** | JavaScript Object Notation |
| **LKR** | Sri Lankan Rupee |
| **MVC** | Model-View-Controller |
| **NFR** | Non-Functional Requirement |
| **OCR** | Optical Character Recognition |
| **ORM** | Object-Relational Mapping |
| **OTP** | One-Time Password |
| **PK** | Primary Key |
| **RBAC** | Role-Based Access Control |
| **REST** | Representational State Transfer |
| **RSVP** | Répondez s'il vous plaît (Event Attendance Confirmation) |
| **SDK** | Software Development Kit |
| **SKU** | Stock Keeping Unit |
| **SL** | Sri Lanka |
| **SQL** | Structured Query Language |
| **UAT** | User Acceptance Testing |
| **UI / UX** | User Interface / User Experience |
| **UML** | Unified Modeling Language |
| **2FA** | Two-Factor Authentication |

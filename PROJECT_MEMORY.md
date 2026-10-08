# Men's Sexual Wellness Platform — Project Memory

## Project identity

- **Product:** Men's Sexual Wellness Platform
- **Purpose:** A private mobile wellness product for education, self-assessment, personalized non-medical plans, progress tracking, AI coaching, subscriptions, and community.
- **MVP scope:** Defined in the attached master implementation prompt; detailed traceability is in `PROJECT_REQUIREMENTS.md`.
- **Current implementation phase:** Phase 0 — repository forensics complete; Phase 1 not started.
- **Target version:** MVP v1.0
- **Last verified:** 2026-10-09

## Verified architecture and current state

This repository is a pnpm TypeScript monorepo starter, not an existing wellness application. It has an Express API artifact, a component-preview/design artifact, shared TypeScript libraries, and no product-domain implementation. The only API operation is a health check. The database library is configured for PostgreSQL through `DATABASE_URL`, but its schema is empty.

The requested target architecture is one Flutter/Dart mobile app for Android and iOS communicating with an independent Django REST Framework modular-monolith API, PostgreSQL, Redis, and Celery. That target does not yet exist in this repository. The current starter uses Express 5, Drizzle ORM, Node.js, and generated TypeScript API clients. Do not claim the requested stack is implemented.

The project prompt is the product requirements source. The user's requested Flutter/Django architecture takes precedence over starter defaults; do not silently substitute Expo, Express, or a different persistence/business-logic layer. Record and explain any necessary deviation before making it.

## Technology status

| Area | Verified current state | Requested target | Status |
|---|---|---|---|
| Mobile | No mobile application; Flutter is not installed in the inspected environment | Flutter/Dart, one Android/iOS codebase | Not started; toolchain/runtime validation needed |
| API | Express 5 health-check service | Python, Django, Django REST Framework | Not started; architectural mismatch |
| Data | Drizzle PostgreSQL adapter and empty schema; database provisioning/connection not verified | PostgreSQL, pgvector where retrieval requires it | No product tables or migrations |
| Jobs/cache | None found | Redis, Celery, transactional outbox | Not started |
| API contract | OpenAPI 3.1 health-only spec; Orval clients for TypeScript | Versioned product API and synchronized contract | Not started |
| Auth, AI, storage, payments | No product integrations or implementation found | Backend-authoritative auth/entitlements, safe AI, storage, billing | Not started |

## Repository map

- `artifacts/api-server/` — registered Express API artifact and health endpoint.
- `artifacts/mockup-sandbox/` — registered component preview/design artifact; not the product mobile app.
- `lib/api-spec/` — OpenAPI source and Orval code generation.
- `lib/api-zod/` — generated TypeScript/Zod API contract package.
- `lib/api-client-react/` — generated React Query client; not a Flutter client.
- `lib/db/` — Drizzle PostgreSQL adapter and currently empty schema.
- `scripts/` — workspace utility package.
- `PROJECT_REQUIREMENTS.md`, `TECH_STACK.md`, `DEPENDENCIES.md`, `PROJECT_FILES.md` — Phase 0 implementation records.

## Domain ownership

No product domain is implemented. The requested backend is responsible for identity, assessment, wellness, content, programs, personalization, plans, tracking, progress, AI safety, community, moderation, billing/entitlements, notifications, privacy, analytics, and administration. PostgreSQL is the requested system of record; AI is not a data store or business-rule authority; the mobile client is not an authorization authority.

## Database state

- No application tables, relations, indexes, constraints, RLS policies, or extensions are defined.
- No application migrations were found.
- Drizzle configuration requires `DATABASE_URL`; actual database provisioning and connectivity were not verified.
- No pgvector, Redis, or Celery configuration is present.

## API state

- Implemented: `GET /api/healthz`, returning `{ "status": "ok" }`.
- Contract: OpenAPI 3.1 at `lib/api-spec/openapi.yaml`, base URL `/api`, version `0.1.0`; only `/healthz` is specified.
- No product API version prefix, auth, authorization, idempotency, or domain endpoints are implemented.
- The generated clients are TypeScript-oriented; there is no Flutter/Dart API client.

## Mobile state

No mobile screens, navigation, state management, authentication flow, API client, local/secure storage, deep links, notification configuration, or Android/iOS project files were found.

## Security state

No product authentication, authorization/RBAC, object-level authorization, RLS, CSRF policy, rate limiting, audit trail, privacy operations, or sensitive-data workflow is implemented. The API has Pino request logging that omits query strings from its serialized request URL; this is not sufficient evidence of sexual-health data-safe logging. No secrets were inspected. The workspace's declared `DATABASE_URL` requirement is not evidence that a database is provisioned.

## Testing state

- Existing tests: none found.
- Baseline check: `pnpm run typecheck` passed on 2026-10-09 for the shared libraries, API artifact, design artifact, and scripts.
- API, database, mobile, Android/iOS, end-to-end, security, and AI-safety tests: not present or not run.
- Flutter is not installed; no Android/iOS build verification was performed.

## Known issues

| Issue | Severity | Location | Root cause | Status | Resolution | Verification |
|---|---|---|---|---|---|---|
| Requested Flutter/Django architecture is absent | P0 | Repository architecture | Starter is TypeScript/Express/Drizzle; requested app stack is Flutter/Django/DRF | Open | Establish the requested stack without duplicating business logic; validate Replit run/build support before claiming platform readiness | Inventory and manifests inspected |
| No wellness product implementation | P0 | All product domains | Repository contains starter artifacts only | Open | Implement in scoped phases against `PROJECT_REQUIREMENTS.md` | Source inventory |
| Database has no domain schema or migrations | P0 | `lib/db/` | Starter schema is empty; Django persistence is not present | Open | Implement PostgreSQL schema and migrations after target backend foundation is settled | Schema/config inspected |
| No Flutter toolchain or mobile project | P0 | Workspace | No `pubspec.yaml`, `lib/main.dart`, Android/iOS project, or `flutter` executable | Open | Validate installation/build options; test Android and iOS separately where supported | File inventory and `flutter --version` |
| Product data and auth configuration are unverified | P0 | Environment/auth | No product auth or database integration configured in inspected project state | Open | Use approved managed auth and configure required runtime services without exposing secrets | Manifests and environment declaration inspected; no credentials read |

## Decisions

### ADR-001 — Honor the requested target architecture; do not disguise starter technology as the product stack

- **Old state:** The repository starter uses Express, Drizzle, and TypeScript-generated clients.
- **New target:** Flutter/Dart mobile and Django/DRF backend, with PostgreSQL and Redis/Celery as specified by the product brief.
- **Reason:** The attached specification explicitly requires this architecture and prohibits silent substitutions or duplicated business logic.
- **Impact:** The existing API artifact and TypeScript data/API libraries cannot be represented as the completed product backend or mobile client.
- **Migration plan:** Establish the Django API and Flutter app as the authoritative product implementation; preserve or remove starter code only when its role is clear; keep the OpenAPI contract synchronized; validate actual Replit workflow/build support before calling the app runnable. Do not use Docker or containers in this Replit environment.
- **Status:** Target recorded; implementation not started.

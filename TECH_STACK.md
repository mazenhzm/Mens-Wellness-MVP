# Technology Stack

This document distinguishes what the repository currently uses from the requested target. A requirement or detected runtime is not evidence that a dependency is implemented or production-ready.

## Current, verified starter stack

| Name | Version | Purpose | Where used | Why selected | Alternatives considered | Security considerations | License | Required configuration |
|---|---|---|---|---|---|---|---|---|
| pnpm workspace | pnpm 10.26.1 detected | Monorepo package management | Root workspace and packages | Existing repository convention | npm, yarn | Respect lockfile and minimum-release-age policy | MIT (pnpm) | `pnpm-workspace.yaml`, `pnpm-lock.yaml` |
| Node.js | 24.13.0 detected | Runs the existing TypeScript services and build tools | API, design artifact, scripts | Existing workspace/runtime | Python for requested API; Bun | Keep runtime patched; do not expose sensitive data in logs | MIT | Workflow supplies `PORT`; API requires it |
| TypeScript | `~5.9.3` in root manifest | Static typing for starter packages | API, shared libraries, design sandbox | Existing starter convention | JavaScript | Types do not replace runtime validation or authorization | Apache-2.0 | `tsconfig.base.json` and package configs |
| Express | `^5.2.1` in API manifest | Existing HTTP health-check API | `artifacts/api-server` | Present in starter only | Requested Django REST Framework | Do not add product auth/business logic here if Django becomes authoritative | MIT | API artifact routes `/api`; workflow supplies `PORT` |
| Drizzle ORM / `pg` | Drizzle catalog range; `pg ^8.23.0` | PostgreSQL connection/schema tooling | `lib/db` | Present in starter only | Django ORM | No domain schema, migrations, or RLS exist yet; protect connection credentials | MIT | `DATABASE_URL` required by current DB package |
| PostgreSQL | Server version not verified | Intended relational database adapter target | DB package configuration only; no confirmed instance | Required by product brief and existing adapter | Other SQL stores | Apply least privilege, constraints, backups, and defense-in-depth RLS | PostgreSQL License | `DATABASE_URL`; actual provisioning unverified |
| Zod / `drizzle-zod` | Zod catalog range; `drizzle-zod ^0.8.3` | TypeScript input/output validation and generated schemas | `lib/api-zod`, `lib/db` | Existing starter convention | Django serializers | Validation must be duplicated at trusted server boundary if stack changes | MIT | Generated schema code; Zod imported from `zod/v4` where configured |
| OpenAPI 3.1 + Orval | API contract `0.1.0`; Orval `^8.30.0` | Contract-first API docs and TypeScript code generation | `lib/api-spec` | Existing starter workflow | Handwritten clients | Keep schema synchronized; generated types are not authorization | OpenAPI Initiative License; Orval MIT | `lib/api-spec/openapi.yaml`; run package codegen |
| React / Vite / React Query | React catalog pin `19.1.0`; Vite catalog `^7.3.2`; Query `^5.90.21` | Component sandbox and generated React API client | `artifacts/mockup-sandbox`, `lib/api-client-react` | Existing design/tooling artifacts | Flutter for the requested consumer app | Sandbox is not the product mobile app; do not place sensitive product data there | MIT | Artifact-managed `PORT` and `BASE_PATH` |
| Pino / pino-http | Pino `^9.14.0`; pino-http `^10.5.0` | Existing structured server logging | `artifacts/api-server` | Existing starter | Python logging | Current request serializer omits query strings; sensitive body/header redaction is not verified | MIT | Logger configuration in API source |

## Requested target stack — not yet implemented

| Name | Version | Purpose | Where used | Why selected | Alternatives considered | Security considerations | License | Required configuration |
|---|---|---|---|---|---|---|---|---|
| Flutter / Dart | Not installed; version not selected | One native-oriented codebase for Android and iOS | Planned `mobile/` application | Explicit product requirement | Expo/React Native is not an approved substitute | Secure storage, platform permissions, privacy-safe telemetry, and per-platform validation | BSD-3-Clause (Flutter SDK); Dart SDK license | Flutter SDK, Android SDK; iOS signing/build requires Apple tooling |
| Django | Not installed; version not selected | Backend modular monolith and authoritative domain services | Planned API service | Explicit product requirement | Existing Express starter is not the product target | Harden settings, secrets, cookies/tokens, admin, and error handling | BSD-3-Clause | Python runtime, environment-based settings, deployment entrypoint |
| Django REST Framework | Not installed; version not selected | REST/JSON API serializers, permissions, and view layer | Planned Django API | Explicit product requirement | Express/Zod starter | Enforce server validation and object-level permissions | BSD-3-Clause | Django app configuration and API version route |
| PostgreSQL + pgvector | PostgreSQL version not verified; extension not present | Source of truth; vector retrieval only where approved RAG requires it | Planned backend | Explicit product requirement | Existing empty Drizzle adapter | Constraints, migrations, least privilege, privacy, and RLS as defense-in-depth | PostgreSQL License; pgvector PostgreSQL License | Provisioned DB, migrations, extension only when needed |
| Redis | Not installed/configured; version not selected | Cache and Celery broker/backend as justified | Planned infrastructure | Explicit product requirement | Direct synchronous jobs | No sensitive health payloads in cache without defined controls | BSD-3-Clause | Redis endpoint, auth/network policy, TTL strategy |
| Celery | Not installed/configured; version not selected | Backend-owned asynchronous jobs | Planned backend | Explicit product requirement | Scheduled synchronous work | Idempotent tasks, retries, least-privilege workers, outbox dispatch | BSD-3-Clause | Broker, worker and scheduler configuration |
| OpenAPI 3.1 | Current health-only document is version 0.1.0 | Versioned product API contract | Planned backend/client boundary | Existing contract-first tooling; explicit API documentation requirement | Undocumented handwritten endpoints | Do not publish sensitive schemas or treat generated clients as trust boundaries | OpenAPI Initiative License | Versioned schemas and synchronized generation |

## Optional integrations

AI gateway/model, approved-content storage/vector retrieval, object storage, payment provider, email delivery, and push notification provider are product requirements but no provider has been selected or connected. Do not add SDKs or claim these services are configured until selection and credentials are handled through the approved integration/secrets flows.

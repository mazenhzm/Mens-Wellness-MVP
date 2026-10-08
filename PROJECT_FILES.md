# Project File Responsibilities

Only architecture-critical and business-critical files are catalogued here; generated UI primitives and other mechanical scaffold files are intentionally grouped.

## Project records

### `PROJECT_MEMORY.md`
- **Purpose:** Verified project state, technology status, domain ownership, known issues, and architecture decisions.
- **Domain:** Cross-cutting project governance.
- **Dependencies:** Repository inspection and the attached product specification.
- **Consumers:** All contributors and implementation agents.
- **Important sections:** Architecture, database/API/mobile/security/testing state, known issues, ADRs.
- **Security responsibility:** Must not contain secrets or private user data.
- **Data responsibility:** Records verified status only.
- **Allowed changes:** Update after evidence changes; preserve distinction between current and target state.
- **Forbidden responsibilities:** Do not treat plans as implemented features.
- **Testing:** Review against source and workflow behavior.
- **Status:** IMPLEMENTED (Phase 0).

### `PROJECT_REQUIREMENTS.md`
- **Purpose:** Traceable product and quality requirements with priority, status, and verification methods.
- **Domain:** Product-wide.
- **Dependencies:** Attached product specification.
- **Consumers:** Product implementation, tests, and release review.
- **Security responsibility:** Tracks privacy, security, authorization, and AI-safety requirements.
- **Data responsibility:** None; requirements only.
- **Allowed changes:** Add or update requirement rows while preserving IDs and evidence-backed statuses.
- **Forbidden responsibilities:** Do not mark a requirement complete without verification.
- **Testing:** Requirement verification methods become test/release evidence.
- **Status:** IMPLEMENTED (Phase 0).

### `TECH_STACK.md` and `DEPENDENCIES.md`
- **Purpose:** Separate verified technologies from requested-but-unimplemented targets; inventory direct dependencies and provider choices.
- **Domain:** Architecture and supply-chain governance.
- **Dependencies:** Package manifests, lockfile, environment/toolchain observations, product specification.
- **Consumers:** Developers, security review, setup and release documentation.
- **Security responsibility:** Track licenses, version/configuration, secret handling, and dependency status.
- **Data responsibility:** None.
- **Allowed changes:** Update when a technology or dependency is actually introduced or removed.
- **Forbidden responsibilities:** Do not list a planned dependency as installed or configured.
- **Testing:** Cross-check against manifests, lockfiles, and build output.
- **Status:** IMPLEMENTED (Phase 0).

## Existing architecture-critical files

### `replit.md`
- **Purpose:** Workspace run commands, stack notes, and collaborator guidance.
- **Domain:** Project operation.
- **Dependencies:** Workspace manifests and artifact configuration.
- **Consumers:** Contributors operating the current starter.
- **Security responsibility:** Names required environment variables but must never contain their values.
- **Data responsibility:** Documents current PostgreSQL adapter requirement.
- **Allowed changes:** Keep instructions accurate as architecture evolves.
- **Forbidden responsibilities:** Do not use it as a source of truth for unverified product features.
- **Testing:** Compare commands to current scripts/workflows.
- **Status:** IMPLEMENTED (starter documentation; product documentation remains in Phase 0 records).

### `package.json`, `pnpm-workspace.yaml`, `pnpm-lock.yaml`
- **Purpose:** Define workspace packages, scripts, toolchain, dependency ranges, lock resolution, and package security policy.
- **Domain:** Build and dependency management.
- **Dependencies:** pnpm and Node.js.
- **Consumers:** All TypeScript packages and CI/workflows.
- **Security responsibility:** Lock dependency resolution; preserve minimum-release-age policy.
- **Data responsibility:** None.
- **Allowed changes:** Package-scoped dependency changes with lockfile updates.
- **Forbidden responsibilities:** Do not add project-wide packages to root without a workspace need.
- **Testing:** `pnpm run typecheck`; package builds as relevant.
- **Status:** IMPLEMENTED (starter).

### `artifacts/api-server/.replit-artifact/artifact.toml`
- **Purpose:** Registers the API service at `/api` and defines its Replit workflow/build/run configuration.
- **Domain:** API runtime/development operations.
- **Dependencies:** `@workspace/api-server`, assigned port, artifact workflow.
- **Consumers:** Replit preview/workflow/deployment runtime.
- **Security responsibility:** Route and runtime configuration; no secret values should be stored here.
- **Data responsibility:** None.
- **Allowed changes:** Only through validated artifact metadata workflow, not direct editing.
- **Forbidden responsibilities:** Do not create duplicate workflows for the same service.
- **Testing:** Restart the managed workflow and verify `/api/healthz` after relevant changes.
- **Status:** IMPLEMENTED (starter API artifact).

### `artifacts/api-server/src/app.ts`
- **Purpose:** Creates the Express application, request logging, CORS/body middleware, and `/api` router mount.
- **Domain:** Current starter API transport.
- **Dependencies:** Express, CORS, Pino HTTP, route index, logger.
- **Consumers:** `src/index.ts`.
- **Security responsibility:** Middleware and request-log serialization; no domain authorization exists.
- **Data responsibility:** HTTP request parsing only.
- **Allowed changes:** Transport-level changes while Express remains authoritative.
- **Forbidden responsibilities:** Do not add business rules or treat this starter as the requested Django API.
- **Testing:** API/type checks and route tests when added.
- **Status:** IMPLEMENTED (health-only starter).

### `artifacts/api-server/src/index.ts`
- **Purpose:** Starts the current Express server on workflow-provided `PORT`.
- **Domain:** Current starter API runtime.
- **Dependencies:** `app.ts`, logger, `PORT`.
- **Consumers:** Managed API workflow.
- **Security responsibility:** Fails startup when port configuration is invalid.
- **Data responsibility:** None.
- **Allowed changes:** Runtime startup changes if preserving this service.
- **Forbidden responsibilities:** Do not implement domain behavior here.
- **Testing:** Managed workflow startup and health check.
- **Status:** IMPLEMENTED (health-only starter).

### `artifacts/api-server/src/routes/index.ts` and `src/routes/health.ts`
- **Purpose:** Mount the current router and implement `GET /healthz`.
- **Domain:** Health/operations only.
- **Dependencies:** Express Router and generated health Zod schema.
- **Consumers:** API app and OpenAPI health contract.
- **Security responsibility:** No user or domain data is served.
- **Data responsibility:** Returns static health status.
- **Allowed changes:** Keep route and schema synchronized.
- **Forbidden responsibilities:** Do not treat health status as database or domain readiness.
- **Testing:** Health endpoint test and OpenAPI conformance.
- **Status:** IMPLEMENTED (starter).

### `lib/api-spec/openapi.yaml`
- **Purpose:** Contract source for the existing health endpoint.
- **Domain:** API contract.
- **Dependencies:** OpenAPI 3.1 and Orval configuration.
- **Consumers:** Generated TypeScript/Zod API clients.
- **Security responsibility:** Contract documentation only; not runtime access control.
- **Data responsibility:** Currently defines only `HealthStatus`.
- **Allowed changes:** Add product operations before corresponding API client generation.
- **Forbidden responsibilities:** Do not let generated clients authorize requests.
- **Testing:** Run codegen and contract checks after every spec change.
- **Status:** IMPLEMENTED (health-only contract).

### `lib/db/src/index.ts`, `lib/db/src/schema/index.ts`, `lib/db/drizzle.config.ts`
- **Purpose:** Configure the current Drizzle PostgreSQL adapter and empty schema.
- **Domain:** Current starter persistence adapter.
- **Dependencies:** `DATABASE_URL`, Drizzle, `pg`, drizzle-kit.
- **Consumers:** Current TypeScript API packages if imported.
- **Security responsibility:** Database credentials come only from managed environment configuration; no application authorization or RLS policies exist.
- **Data responsibility:** No product tables currently.
- **Allowed changes:** Only if this library remains part of the supported architecture.
- **Forbidden responsibilities:** Do not duplicate Django's authoritative domain persistence with parallel TypeScript models.
- **Testing:** Schema/migration tests if retained; DB connection must be explicitly configured.
- **Status:** IMPLEMENTED (empty starter schema).

### `artifacts/mockup-sandbox/`
- **Purpose:** Reusable React component preview/design environment.
- **Domain:** Design tooling, not sexual-wellness product functionality.
- **Dependencies:** React, Vite, Tailwind, Radix/shadcn-style components.
- **Consumers:** Design previews.
- **Security responsibility:** Must not receive real sensitive health data.
- **Data responsibility:** None.
- **Allowed changes:** Reusable UI previews.
- **Forbidden responsibilities:** Do not treat it as the requested Flutter application or a production data client.
- **Testing:** Package typecheck/build for changes.
- **Status:** IMPLEMENTED (design tooling).

## Planned architecture files

The prompt's suggested Flutter and Django directories are targets, not existing files. Add entries here when implementation creates meaningful files, documenting the actual security and data responsibility rather than pre-documenting hypothetical classes.

# Project Requirements — Men's Sexual Wellness Platform MVP

**Source:** Attached “MASTER MVP IMPLEMENTATION PROMPT — Men's Sexual Wellness Platform — MVP v1.0”.  
**Status meaning:** `Not started` means no verified product implementation exists; health-check scaffolding does not satisfy product requirements.

| ID | Requirement | Priority | Status | Verification method |
|---|---|---:|---|---|
| ARCH-001 | Use one Flutter/Dart mobile codebase for Android and iOS; keep business-critical logic on the backend. | P0 | Not started | Inspect app structure; build and test Android and iOS targets; verify clients call backend for domain operations. |
| ARCH-002 | Use a modular-monolith Django/DRF API, with views/serializers delegating business rules to application/domain services. | P0 | Not started | Architecture inspection and service/API tests. |
| ARCH-003 | Make PostgreSQL the system of record; use Redis/Celery and an outbox for asynchronous, idempotent side effects. | P0 | Not started | Schema/migration review; integration tests for transactions, task delivery, retries, and idempotency. |
| API-001 | Maintain a versioned REST/JSON API and synchronized OpenAPI 3.1 contract. | P0 | Not started | Contract lint/code generation; compare documented operations to routed endpoints. |
| ID-001 | Provide registration, login, logout, email verification, and password reset using a secure auth flow. | P0 | Not started | Auth-provider integration tests and mobile flow tests on both platforms. |
| ID-002 | Keep authentication, authorization, profile, consent, and account lifecycle authoritative on the backend. | P0 | Not started | API authorization tests; inspect client for prohibited authority. |
| ID-003 | Enforce object-level authorization for every user-owned resource. | P0 | Not started | Cross-user access-denial tests for each protected resource. |
| ID-004 | Store user profile and consent state with explicit privacy and lifecycle handling. | P0 | Not started | API/database tests for create, update, revoke, export, and delete behavior. |
| ASM-001 | Implement versioned assessments and persist responses/results server-side. | P0 | Not started | Assessment unit/API tests covering versioning, validation, and ownership. |
| ASM-002 | Derive a wellness profile from assessment through deterministic backend rules. | P0 | Not started | Golden-plan/domain tests with documented inputs and expected outputs. |
| PRG-001 | Version programs and evaluate eligibility on the backend. | P0 | Not started | Eligibility rule tests and version migration tests. |
| PER-001 | Keep personalization rules deterministic, versioned, explainable, and distinct from AI output. | P0 | Not started | Golden tests and code review of rule ownership. |
| PLN-001 | Generate a personal daily plan from approved programs and user wellness data. | P0 | Not started | Golden-plan tests; API integration tests for ownership and reproducibility. |
| TRK-001 | Record user progress/tracking through validated, authorized, idempotent operations. | P0 | Not started | API tests for validation, duplicate requests, authorization, and persistence. |
| TRK-002 | Adapt future plans only through approved backend rules; preserve a clear history of changes. | P0 | Not started | Domain tests for adaptation inputs, outputs, and audit history. |
| AI-001 | Route AI through a backend gateway; version prompts and safety policies. | P0 | Not started | AI gateway contract tests and prompt/policy version assertions. |
| AI-002 | AI must not diagnose, prescribe, or create medical treatment; provide safe escalation language when indicated. | P0 | Not started | Safety test suite with prohibited requests and escalation cases. |
| AI-003 | Use only approved content as RAG knowledge; never treat model output as database truth or authorization. | P0 | Not started | Retrieval provenance tests; inspect model boundaries and mutation capabilities. |
| AI-004 | Prevent AI from directly mutating critical domain state. | P0 | Not started | Permission/contract tests proving AI endpoints cannot bypass domain services. |
| COM-001 | Implement community access and permissions on the backend, with privacy-preserving user identity. | P1 | Not started | Permission and anonymity tests across roles and resources. |
| COM-002 | Implement moderation/reporting and content safety workflows before enabling community use. | P1 | Not started | Moderation workflow tests and abuse-case review. |
| BILL-001 | Represent subscription entitlements on the backend; never trust a mobile-reported subscription state. | P0 | Not started | Webhook/entitlement tests and forged-client-state denial tests. |
| BILL-002 | Make payment-provider events idempotent and reconcile them to internal entitlement state. | P0 | Not started | Duplicate/out-of-order webhook integration tests. |
| PRIV-001 | Provide user privacy operations, including data access/export and deletion, with documented side effects. | P0 | Not started | API tests that inspect all owned domains and asynchronous cleanup completion. |
| PRIV-002 | Minimize collection/retention of sensitive sexual-health data and apply access controls per domain. | P0 | Not started | Data inventory, retention review, authorization tests, and privacy review. |
| SEC-001 | Use TLS for network traffic and secure mobile session storage; never store credentials or bearer tokens insecurely. | P0 | Not started | Configuration review and mobile storage tests. |
| SEC-002 | Apply least privilege, input validation, rate limiting, audit logging, and safe error handling. | P0 | Not started | Security tests, abuse/rate-limit tests, and log/error inspection. |
| SEC-003 | Use database constraints and RLS as defense-in-depth, never as a substitute for application authorization. | P0 | Not started | Migration review and database/API authorization tests. |
| SEC-004 | Never log sensitive sexual-health information or commit secrets. | P0 | Not started | Structured-log redaction tests and repository secret scan. |
| SEC-005 | Make asynchronous side effects idempotent and use a transactional outbox for domain events. | P0 | Not started | Failure/retry integration tests and transaction-boundary review. |
| MOB-001 | Support accessible navigation and forms on phone-sized Android and iOS screens. | P0 | Not started | Accessibility checks and manual device/simulator testing. |
| MOB-002 | Support Arabic and correct right-to-left layout, alongside the selected default locale. | P0 | Not started | Arabic locale visual/functional tests on both platform targets. |
| MOB-003 | Keep local storage minimal; protect any necessary private data and clear it on logout/account deletion. | P0 | Not started | Device-storage inspection and lifecycle tests. |
| MOB-004 | Implement authentication, onboarding, assessment, main plan/progress, coach, billing, community, and profile screens. | P0 | Not started | Route/screen inventory and end-to-end mobile tests. |
| NOTIF-001 | Deliver notifications through backend-controlled, consent-aware jobs; do not expose sensitive content on lock screens by default. | P1 | Not started | Consent, payload redaction, scheduling, and delivery tests. |
| ANALYTICS-001 | Use privacy-aware analytics that exclude sensitive assessment/sexual-health content. | P1 | Not started | Event-schema review and automated prohibited-field checks. |
| OBS-001 | Add operational observability without logging sensitive data; distinguish health checks from domain readiness. | P1 | Not started | Health/metrics tests and log redaction verification. |
| TEST-001 | Provide unit, integration, API, mobile, E2E, security, and AI-safety coverage appropriate to each domain. | P0 | Not started | CI/test inventory and recorded platform results. |
| TEST-002 | Maintain golden-plan tests for personalization and plan generation. | P0 | Not started | Execute fixed fixture suite and review deterministic outputs. |
| DEPLOY-001 | Document required configuration and release steps; never commit secrets or claim unsupported platform verification. | P0 | Not started | Release checklist and clean-environment startup verification. |
| DEPLOY-002 | Verify Android and iOS separately before release; document any platform that cannot be tested in this environment. | P0 | Not started | Separate recorded Android/iOS build and test results. |
| DOC-001 | Maintain project state, requirements, stack/dependency inventory, and file responsibility documentation. | P0 | In progress | Review these documents against repository evidence at each implementation phase. |

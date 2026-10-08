# Dependency Inventory

This is a verified inventory of the workspace manifests plus a separate list of target dependencies. Exact installed versions are resolved by `pnpm-lock.yaml`; manifest ranges below are not necessarily the installed version. No mobile, Django, Redis, Celery, AI, storage, or payment dependency is currently implemented.

## Production/runtime dependencies currently declared

### Root workspace

- `@replit/connectors-sdk ^0.4.3` — Replit connector SDK, root runtime dependency; no integration use found in product code.

### API server (`@workspace/api-server`)

- `@workspace/api-zod workspace:*` — generated health contract.
- `@workspace/db workspace:*` — Drizzle database library; no current product route uses it.
- `cookie-parser ^1.4.7`
- `cors ^2.8.6`
- `drizzle-orm catalog:`
- `express ^5.2.1`
- `pino ^9.14.0`
- `pino-http ^10.5.0`

### Database library (`@workspace/db`)

- `drizzle-orm catalog:`
- `drizzle-zod ^0.8.3`
- `pg ^8.23.0`
- `zod catalog:`

### API contract/client libraries

- `@workspace/api-client-react`: `@tanstack/react-query catalog:`; React is a peer dependency (`>=18`).
- `@workspace/api-zod`: generated Zod types; source package and generated outputs currently describe the health operation only.
- `@workspace/api-spec`: no runtime dependency; code generation is a development task.

### Design/component sandbox (`@workspace/mockup-sandbox`)

- React application/runtime: `react`, `react-dom` (both catalog-pinned).
- UI/accessibility primitives: `@radix-ui/react-*` packages for accordion, alert dialog, aspect ratio, avatar, checkbox, collapsible, context menu, dialog, dropdown menu, hover card, label, menubar, navigation menu, popover, progress, radio group, scroll area, select, separator, slider, slot, switch, tabs, toast, toggle, toggle group, and tooltip.
- UI/forms/interaction: `@hookform/resolvers`, `react-hook-form`, `input-otp`, `cmdk`, `embla-carousel-react`, `react-resizable-panels`, `vaul`, `sonner`.
- Styling/animation: `class-variance-authority`, `clsx`, `tailwind-merge`, `tailwindcss`, `tailwindcss-animate`, `tw-animate-css`, `@tailwindcss/vite`, `framer-motion`, `next-themes`.
- Data/display/helpers: `date-fns`, `recharts`, `lucide-react`.
- Vite support: `vite`, `@vitejs/plugin-react`, `@replit/vite-plugin-cartographer`, `@replit/vite-plugin-runtime-error-modal`, `chokidar`, `fast-glob`, `zod`.
- These dependencies belong to a reusable UI/design sandbox, not the Flutter consumer app.

## Development/build dependencies currently declared

- Root: `prettier ^3.9.6`, `typescript ~5.9.3`.
- API server: `@types/cookie-parser ^1.4.10`, `@types/cors ^2.8.19`, `@types/express ^5.0.6`, `@types/node catalog:`, `esbuild 0.28.2`, `esbuild-plugin-pino ^2.3.3`, `pino-pretty ^13.1.3`, `thread-stream 3.1.0`.
- Database: `@types/node catalog:`, `@types/pg ^8.23.1`, `drizzle-kit ^0.31.10`.
- API spec/codegen: `orval ^8.30.0`.
- Mockup sandbox: `@types/node`, `@types/react`, `@types/react-dom` (catalog), `vite`, `@vitejs/plugin-react`, `@replit/vite-plugin-cartographer`, `@replit/vite-plugin-runtime-error-modal`, and the UI packages listed above (all used for the sandbox build).
- Scripts: TypeScript toolchain; no product runtime dependencies identified.

## Planned dependencies — not installed

### Mobile

- Flutter and Dart SDK, plus only the Flutter packages required for routing, state, networking, secure storage, localization, and accessibility after those choices are documented.
- No package names or versions are approved yet; do not translate the generated React hooks into the mobile app.

### Backend and infrastructure

- Django, Django REST Framework, and a PostgreSQL driver for the Python runtime.
- PostgreSQL server; pgvector only if approved RAG retrieval needs vector search.
- Redis and Celery for specified asynchronous processing.
- Exact versions and licensing review are pending environment/toolchain validation.

### Optional/provider-specific

- AI gateway/model SDK, object-storage client, payment SDK, email provider, push provider, and analytics SDK are not selected or installed.
- Add these only after provider choice, integration availability, data-flow/security review, and required configuration are documented.

## Dependency policy

- Keep the pnpm release-age protection in `pnpm-workspace.yaml`.
- Do not add multiple libraries that solve the same domain problem.
- Re-evaluate the existing TypeScript API/database stack when Django becomes the authoritative backend; avoid keeping unused runtime dependencies merely because the scaffold supplied them.
- Record package names, versions, licenses, purpose, and security configuration in `TECH_STACK.md` when target dependencies are actually added.

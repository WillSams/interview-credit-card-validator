# Credit Card Validator

**TypeScript · React · Material UI · Zustand · Fastify · AWS Lambda · S3 · CloudFront · Terraform**

[![Application Unit Tests](https://github.com/WillSams/interview-credit-card-validator/actions/workflows/pr-validate.yml/badge.svg)](https://github.com/WillSams/interview-credit-card-validator/actions/workflows/pr-validate.yml)

A full-stack credit card validation app. Enter a card number and the backend validates it using the Luhn checksum algorithm.

![text](screenshot.png)

## Assumptions

### Functional

- Validation is performed exclusively in the backend via `POST /validate` — the frontend never runs the Luhn algorithm itself
- The input accepts common formatting characters (spaces and dashes) and strips them before validation
- Only the Luhn checksum is evaluated — the app does not detect card network (Visa, Mastercard, etc.), check card length by network, or validate expiry or CVV

### Non-Functional

- **No authentication** — the API is open; any caller can POST to `/validate`
- **No persistence** — validation results are not stored anywhere; each request is stateless
- **No rate limiting** — the API does not throttle requests
- **Serverless** — the backend is designed for bursty/low-volume traffic as an AWS Lambda function; a long-running server would be more appropriate for sustained high throughput
- **CORS** — allowed origins are configured via the `ALLOWED_ORIGINS` environment variable; defaults to `*` in development

## Tech Stack

| Layer | Tech |
|---|---|
| Frontend | React 18, Material UI, Zustand, React Router, Vite, Vitest |
| Backend | Fastify 5, AWS Lambda (`@fastify/aws-lambda`), esbuild |
| Infrastructure | Terraform — Lambda, API Gateway (HTTP), S3, CloudFront, IAM, CloudWatch |
| Quality | ESLint, Prettier, Husky pre-commit + pre-push, GitHub Actions CI |

## Prerequisites

- [Node.js 22](https://nodejs.org/) — use `nvm use` to pick the version in `.nvmrc`
- [nvm](https://github.com/nvm-sh/nvm) *(recommended)*
- [direnv](https://direnv.net/) *(recommended)*

## Getting Started

```bash
# 1. Use the right Node version
nvm use

# 2. Set up environment variables
cp .envrc.example .envrc   # fill in values, then:
direnv allow

# 3. Install all dependencies
npm install
cd frontend && npm install && cd ..
cd backend  && npm install && cd ..

# 4. Start both services
npm run dev
```

The frontend is served at `http://localhost:3000` and the backend at `http://localhost:8080`.

## API

### `POST /validate`

Validates a credit card number using the Luhn checksum algorithm.

- **Request**

```json
{ "cardNumber": "4532 0151 1283 0366" }
```

- **Response**

```json
{ "valid": true }
```

| Status | Meaning |
|---|---|
| `200` | Validation ran — check `valid` for the result |
| `400` | `cardNumber` is missing or not a string |

## Project Structure

```
interview-credit-card-validator/
├── frontend/                  # React SPA (deploys to S3 + CloudFront)
│   └── src/
│       ├── api/               # Axios client
│       ├── components/
│       │   └── CardValidator  # Form + result display
│       ├── pages/             # Route-level components
│       ├── stores/
│       │   └── cardStore      # Zustand store — calls POST /validate
│       └── specs/             # Vitest tests
├── backend/                   # Fastify API (deploys as Lambda)
│   ├── src/
│   │   ├── luhn.ts            # Luhn checksum algorithm
│   │   ├── app.ts             # Fastify instance + routes
│   │   ├── index.ts           # Lambda handler entry point
│   │   └── server.ts          # Local dev server
│   └── specs/                 # Jest tests
└── .github/
    └── workflows/             # CI: lint + test on every PR
```

## Scripts

From the project root:

| Command | Description |
|---|---|
| `npm run dev` | Start frontend + backend concurrently |
| `npm run dev:frontend` | Start frontend only |
| `npm run dev:backend` | Start backend only |
| `npm run test:frontend` | Run frontend tests |
| `npm run test:backend` | Run backend tests |
| `npm run test:frontend:coverage` | Frontend tests with coverage |
| `npm run test:backend:coverage` | Backend tests with coverage |
| `npm run lint:frontend` | Lint frontend |
| `npm run lint:backend` | Lint backend |
| `npm run format:frontend` | Format frontend |
| `npm run format:backend` | Format backend |
| `npm run clean` | Remove all build artefacts and node_modules |

## Testing

```bash
# Backend — Jest (Luhn algorithm + API endpoint)
npm run test:backend

# Frontend — Vitest (store + component)
npm run test:frontend
```

## Code Quality

Pre-commit hooks (Husky) run format + lint on every commit. Pre-push hooks run the full test suite.

GitHub Actions runs lint and tests on every PR to `main`.

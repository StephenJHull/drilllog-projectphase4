# DrilllogWeb

Minimal Express application that verifies connectivity to Microsoft SQL Server.

## Setup

1. Copy `.env.example` to `.env` and set your DB values.
2. Install dependencies:
   - `npm install`
3. Start the app:
   - `npm start`

## Endpoints

- `GET /` - app status
- `GET /health/db` - tests SQL Server connection and returns employee count from `dbo.Employee`

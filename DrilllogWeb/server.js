const express = require("express");
const sql = require("mssql");
const dotenv = require("dotenv");

// Force .env values so empty shell vars do not override local settings.
const dotenvResult = dotenv.config({ override: true });
if (dotenvResult?.error) {
  console.warn("Failed to load .env:", dotenvResult.error.message);
}

const app = express();
const PORT = Number(process.env.PORT || 3000);
const dbUser = ((process.env.DB_USER ?? "").trim());
const dbPassword = ((process.env.DB_PASSWORD ?? "").trim());

const dbConfig = {
  server: process.env.DB_SERVER || "localhost",
  database: process.env.DB_NAME || "DrilllogDB",
  options: {
    trustServerCertificate: true,
    encrypt: false
  }
};

const usingSqlLogin = Boolean(dbUser && dbPassword);

if (usingSqlLogin) {
  dbConfig.user = dbUser;
  dbConfig.password = dbPassword;
} else {
  dbConfig.options.trustedConnection = true;
}

app.get("/", (_req, res) => {
  res.send("Drilllog web app is running. Open /status for DB health UI.");
});

app.get("/status", (_req, res) => {
  res.type("html").send(`<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Drilllog DB Status</title>
  <style>
    :root { color-scheme: light dark; }
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #f5f7fb;
      color: #1f2937;
      display: grid;
      place-items: center;
      min-height: 100vh;
    }
    .card {
      width: min(560px, 92vw);
      background: #fff;
      border: 1px solid #e5e7eb;
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
      padding: 20px;
    }
    h1 { margin: 0 0 10px; font-size: 22px; }
    .row { display: flex; align-items: center; gap: 10px; margin: 10px 0 16px; }
    .dot { width: 12px; height: 12px; border-radius: 999px; background: #9ca3af; }
    .ok { background: #16a34a; }
    .bad { background: #dc2626; }
    .muted { color: #6b7280; font-size: 14px; }
    .pill {
      display: inline-block;
      padding: 3px 10px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
      letter-spacing: .03em;
    }
    .pill-ok { background: #dcfce7; color: #166534; }
    .pill-bad { background: #fee2e2; color: #991b1b; }
    pre {
      margin: 12px 0 0;
      padding: 12px;
      background: #111827;
      color: #f9fafb;
      border-radius: 8px;
      overflow-x: auto;
      font-size: 12px;
    }
    button {
      margin-top: 14px;
      border: 0;
      background: #2563eb;
      color: #fff;
      border-radius: 8px;
      padding: 8px 12px;
      cursor: pointer;
      font-weight: 600;
    }
    button:hover { background: #1d4ed8; }
  </style>
</head>
<body>
  <main class="card">
    <h1>Drilllog DB Status</h1>
    <div class="row">
      <span id="dot" class="dot"></span>
      <strong id="statusText">Checking connection...</strong>
      <span id="badge" class="pill">WAIT</span>
    </div>
    <div class="muted">Endpoint: <code>/health/db</code></div>
    <div class="muted">Database: <span id="dbName">-</span></div>
    <div class="muted">Employee Rows: <span id="employeeCount">-</span></div>
    <button id="refreshBtn" type="button">Refresh</button>
    <pre id="raw">Loading...</pre>
  </main>

  <script>
    async function loadStatus() {
      const dot = document.getElementById("dot");
      const statusText = document.getElementById("statusText");
      const badge = document.getElementById("badge");
      const dbName = document.getElementById("dbName");
      const employeeCount = document.getElementById("employeeCount");
      const raw = document.getElementById("raw");

      try {
        const res = await fetch("/health/db", { cache: "no-store" });
        const data = await res.json();
        dbName.textContent = data.database ?? "-";
        employeeCount.textContent = (data.employeeCount ?? "-").toString();
        raw.textContent = JSON.stringify(data, null, 2);

        if (data.connected) {
          dot.className = "dot ok";
          statusText.textContent = "Database Connected";
          badge.className = "pill pill-ok";
          badge.textContent = "ONLINE";
        } else {
          dot.className = "dot bad";
          statusText.textContent = "Database Not Connected";
          badge.className = "pill pill-bad";
          badge.textContent = "OFFLINE";
        }
      } catch (err) {
        dot.className = "dot bad";
        statusText.textContent = "Database Not Connected";
        badge.className = "pill pill-bad";
        badge.textContent = "ERROR";
        raw.textContent = String(err);
      }
    }

    document.getElementById("refreshBtn").addEventListener("click", loadStatus);
    loadStatus();
  </script>
</body>
</html>`);
});

app.get("/health/db", async (_req, res) => {
  let pool;

  try {
    if (!usingSqlLogin) {
      return res.status(500).json({
        connected: false,
        database: dbConfig.database,
        message: "Missing DB_USER/DB_PASSWORD in .env (SQL login path not configured).",
        dbUserSeen: dbUser || "",
        usingTrustedConnection: true
      });
    }

    pool = await sql.connect(dbConfig);
    const result = await pool.request().query("SELECT COUNT(*) AS employeeCount FROM dbo.Employee;");
    const employeeCount = result.recordset[0]?.employeeCount ?? 0;

    res.status(200).json({
      connected: true,
      database: dbConfig.database,
      employeeCount,
      message: "Connection to Microsoft SQL Server successful."
    });
  } catch (error) {
    res.status(500).json({
      connected: false,
      database: dbConfig.database,
      message: "Connection failed.",
      error: error.message,
      dbUserSeen: dbUser || "",
      usingTrustedConnection: Boolean(dbConfig.options.trustedConnection)
    });
  } finally {
    if (pool) {
      await pool.close();
    }
  }
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});

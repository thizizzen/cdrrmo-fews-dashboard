-- ============================================
-- CDRRMO FEWS Dashboard - Database Seed
-- Run this once on a fresh Supabase project
-- ============================================

CREATE TABLE IF NOT EXISTS users (
    id            SERIAL PRIMARY KEY,
    name          TEXT NOT NULL,
    email         TEXT UNIQUE NOT NULL,
    password      TEXT NOT NULL,
    role          TEXT NOT NULL DEFAULT 'Viewer',
    department    TEXT NOT NULL DEFAULT 'Operations',
    photo         TEXT,
    token_version INTEGER NOT NULL DEFAULT 0,
    phone         VARCHAR(20),
    sms_enabled   BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sensor_readings (
    id             SERIAL PRIMARY KEY,
    device_id      TEXT NOT NULL,
    water_level_cm REAL,
    battery_pct    REAL,
    status         TEXT,
    latitude       REAL,
    longitude      REAL,
    is_immediate   BOOLEAN NOT NULL DEFAULT FALSE,
    timestamp      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS system_logs (
    id        SERIAL PRIMARY KEY,
    station   TEXT NOT NULL DEFAULT 'System',
    type      TEXT NOT NULL DEFAULT 'system',
    message   TEXT NOT NULL,
    user_name TEXT,
    user_id   INTEGER REFERENCES users(id) ON DELETE SET NULL,
    timestamp TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fews_units (
    id                SERIAL PRIMARY KEY,
    device_id         VARCHAR(50) UNIQUE NOT NULL,
    name              VARCHAR(100) NOT NULL,
    location          VARCHAR(100),
    installed_date    VARCHAR(50),
    technician        VARCHAR(100),
    description       TEXT,
    threshold_warning INT NOT NULL DEFAULT 200,
    threshold_danger  INT NOT NULL DEFAULT 300,
    siren_state       BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS system_settings (
    id         SERIAL PRIMARY KEY,
    auto_siren BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_logs_ts ON system_logs (timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_readings_ts ON sensor_readings (device_id, timestamp DESC);

-- Default FEWS 1 unit
INSERT INTO fews_units (device_id, name, location, installed_date, technician, description, threshold_warning, threshold_danger)
VALUES (
    'fews_1',
    'FEWS 1',
    'Bolbok',
    '-',
    'Engr. Andrew Van Ryan',
    'Deployed along the upper tributary of Sta. Rita River. Monitors early upstream surge from heavy rainfall in the Mataas na Gulod watershed.',
    200,
    300
) ON CONFLICT (device_id) DO NOTHING;
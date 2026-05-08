-- =============================================
-- V1: Initial schema for Smart Job Tracker
-- =============================================

CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE companies (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    website     VARCHAR(255),
    industry    VARCHAR(100),
    location    VARCHAR(255),
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE job_applications (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID         NOT NULL,
    company_id       UUID         NOT NULL,
    job_title        VARCHAR(255) NOT NULL,
    job_description  TEXT,
    job_url          VARCHAR(500),
    status           VARCHAR(50)  NOT NULL DEFAULT 'WISHLIST',
    work_mode        VARCHAR(20),
    location         VARCHAR(255),
    salary_min       INTEGER,
    salary_max       INTEGER,
    applied_at       DATE,
    deadline         DATE,
    ai_analysis      JSONB,
    created_at       TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_applications_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

    CONSTRAINT fk_applications_company
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE RESTRICT
);

CREATE TABLE interviews (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id    UUID        NOT NULL,
    interview_type    VARCHAR(30) NOT NULL,
    scheduled_at      TIMESTAMP,
    duration_minutes  INTEGER,
    notes             TEXT,
    outcome           VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_interviews_application
        FOREIGN KEY (application_id) REFERENCES job_applications(id) ON DELETE CASCADE
);

CREATE TABLE application_notes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID NOT NULL,
    content         TEXT NOT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_notes_application
        FOREIGN KEY (application_id) REFERENCES job_applications(id) ON DELETE CASCADE
);

CREATE TABLE application_status_history (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID        NOT NULL,
    old_status      VARCHAR(50),
    new_status      VARCHAR(50) NOT NULL,
    changed_at      TIMESTAMP   NOT NULL DEFAULT NOW(),
    note            VARCHAR(255),

    CONSTRAINT fk_status_history_application
        FOREIGN KEY (application_id) REFERENCES job_applications(id) ON DELETE CASCADE
);

-- =============================================
-- Indexes for query performance
-- =============================================

CREATE INDEX idx_job_applications_user_id   ON job_applications(user_id);
CREATE INDEX idx_job_applications_status    ON job_applications(status);
CREATE INDEX idx_interviews_application_id  ON interviews(application_id);
CREATE INDEX idx_notes_application_id       ON application_notes(application_id);
CREATE INDEX idx_status_history_app_id      ON application_status_history(application_id);

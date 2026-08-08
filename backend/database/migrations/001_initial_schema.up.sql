BEGIN;

CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'student',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT users_role_check
        CHECK (role IN ('student', 'supervisor', 'admin')),

    CONSTRAINT users_email_not_blank_check
        CHECK (BTRIM(name) <> ''),

    CONSTRAINT users_name_not_blank_check
        CHECK (BTRIM(email) <> '')
);

CREATE TABLE internships (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    company_name VARCHAR(200) NOT NULL,
    position VARCHAR(150) NOT NULL,
    supervisor_name VARCHAR(150),
    supervisor_email VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'planned',
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT internships_user_fk
        FOREIGN KEY (user_id) 
        REFERENCES users(id) 
        ON DELETE CASCADE,

    CONSTRAINT internships_status_check
        CHECK (status IN ('planned', 'active', 'completed', 'cancelled')),

    CONSTRAINT internships_date_check
        CHECK (end_date >= start_date),

    CONSTRAINT internships_company_name_not_blank_check
        CHECK (BTRIM(company_name) <> ''),

    CONSTRAINT internships_position_not_blank_check
        CHECK (BTRIM(position) <> ''),
);

CREATE TABLE projects (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    internship_id BIGINT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'planned',
    start_date DATE,
    end_date DATE ,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT projects_internship_fk
        FOREIGN KEY (internship_id) 
        REFERENCES internships(id) 
        ON DELETE CASCADE,

    CONSTRAINT projects_status_check
        CHECK (status IN (
            'not_started'
            'in_progress', 
            'on_hold', 
            'completed', 
            'cancelled'
            )
        ),

    CONTRAINT projects_progress_check
        CHECK (progress BETWEEN 0 AND 100),

    CONSTRAINT projects_date_check
        CHECK (
            start_date IS NULL
            OR end_date IS NULL
            OR end_date >= start_date
        ),

    CONSTRAINT projects_title_not_blank_check
        CHECK (BTRIM(title) <> '')
);

CREATE TABLE tasks (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'todo',
    priority VARCHAR(20) NOT NULL DEFAULT 'medium',
    due_date DATE,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT tasks_project_fk
        FOREIGN KEY (project_id) 
        REFERENCES projects(id) 
        ON DELETE CASCADE,

    CONSTRAINT tasks_status_check
        CHECK (status IN (
            'todo', 
            'in_progress', 
            'completed', 
            'cancelled'
            )
        ),

    CONSTRAINT tasks_priority_check
        CHECK (priority IN (
            'low', 
            'medium', 
            'high',
            'urgent'
            )
        ),

    CONSTRAINT tasks_completed_at_check
        CHECK (
            status = 'completed' OR completed_at IS NULL
        )

    CONSTRAINT tasks_title_not_blank_check
        CHECK (BTRIM(title) <> '')
);

CREATE TABLE technologies (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT technologies_category_check
        CHECK (
            category IN (
                'frontend', 
                'backend', 
                'database', 
                'devops', 
                'mobile', 
                'other'
            );
        )

    CONSTRAINT technologies_name_not_blank_check
        CHECK (BTRIM(name) <> '')
);

CREATE TABLE project_technologies (
    project_id BIGINT NOT NULL,
    technology_id BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT project_technologies_pk
        PRIMARY KEY (project_id, technology_id),

    CONSTRAINT project_technologies_project_fk
        FOREIGN KEY (project_id)
        REFERENCES projects(id)
        ON DELETE CASCADE,

    CONSTRAINT project_technologies_technology_fk
        FOREIGN KEY (technology_id)
        REFERENCES technologies(id)
        ON DELETE CASCADE
);

CREATE TABLE weekly_reports (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    internship_id BIGINT NOT NULL,
    week_number INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    summary TEXT,
    challenges TEXT,
    reflection TEXT,
    total_hours INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT weekly_reports_internship_fk
        FOREIGN KEY (internship_id)
        REFERENCES internships(id)
        ON DELETE CASCADE,

    CONSTRAINT weekly_reports_week_number_check
        CHECK (week_number > 0),

    CONSTRAINT weekly_reports_date_check
        CHECK (end_date >= start_date),

    CONSTRAINT weekly_reports_hours_check
        CHECK (total_hours BETWEEN 0 AND 168),

    CONSTRAINT weekly_reports_status_check
        CHECK (status IN ('draft', 'submitted', 'reviewed')),

    CONSTRAINT weekly_reports_internship_week_unique
        UNIQUE (internship_id, week_number)
);

CREATE TABLE daily_activities (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    weekly_report_id BIGINT NOT NULL,
    activity_date DATE NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    hours NUMERIC(4, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT daily_activities_weekly_report_fk
        FOREIGN KEY (weekly_report_id)
        REFERENCES weekly_reports(id)
        ON DELETE CASCADE,

    CONSTRAINT daily_activities_hours_check
        CHECK (hours > 0 AND hours <= 24),

    CONSTRAINT daily_activities_title_not_blank_check
        CHECK (BTRIM(title) <> '')
);

CREATE INDEX internships_user_id_idx
    ON internships(user_id);

CREATE INDEX projects_internship_id_idx
    ON projects(internship_id);

CREATE INDEX tasks_project_id_idx
    ON tasks(project_id);

CREATE INDEX tasks_status_idx
    ON tasks(status);

CREATE INDEX tasks_due_date_idx
    ON tasks(due_date);

CREATE INDEX weekly_reports_internship_id_idx
    ON weekly_reports(internship_id);

CREATE INDEX daily_activities_weekly_report_id_idx
    ON daily_activities(weekly_report_id);

COMMIT;
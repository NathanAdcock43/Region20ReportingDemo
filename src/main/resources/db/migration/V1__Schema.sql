CREATE SCHEMA IF NOT EXISTS app;

CREATE TABLE IF NOT EXISTS app.students (
                                            student_id SERIAL PRIMARY KEY,
                                            first_name TEXT NOT NULL,
                                            last_name  TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS app.courses (
                                           course_id SERIAL PRIMARY KEY,
                                           name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS app.assessments (
                                               assessment_id SERIAL PRIMARY KEY,
                                               course_id INT NOT NULL REFERENCES app.courses(course_id),
    name TEXT NOT NULL,
    weight_pct NUMERIC(5,2) NOT NULL CHECK (weight_pct BETWEEN 0 AND 100)
    );

CREATE TABLE IF NOT EXISTS app.enrollments (
                                               enrollment_id SERIAL PRIMARY KEY,
                                               student_id INT NOT NULL REFERENCES app.students(student_id),
    course_id  INT NOT NULL REFERENCES app.courses(course_id),
    term TEXT NOT NULL
    );

CREATE TABLE IF NOT EXISTS app.scores (
                                          score_id SERIAL PRIMARY KEY,
                                          assessment_id INT NOT NULL REFERENCES app.assessments(assessment_id),
    student_id INT NOT NULL REFERENCES app.students(student_id),
    points_earned NUMERIC(10,2) NOT NULL,
    points_possible NUMERIC(10,2) NOT NULL,
    scored_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

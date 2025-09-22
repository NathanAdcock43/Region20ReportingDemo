-- Enforce one score per (student, assessment)
ALTER TABLE app.scores
    ADD CONSTRAINT uq_scores_student_assessment
        UNIQUE (student_id, assessment_id);

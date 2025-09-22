-- 1) Insert or update a score, then return updated course percentage
CREATE OR REPLACE FUNCTION app.usp_record_score_and_course_pct(
  p_student_id INT,
  p_assessment_id INT,
  p_earned NUMERIC,
  p_possible NUMERIC
)
RETURNS TABLE (course_grade_pct NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
v_course_id INT;
BEGIN
  -- Upsert: keep only one score row per (student, assessment)
INSERT INTO app.scores (student_id, assessment_id, points_earned, points_possible)
VALUES (p_student_id, p_assessment_id, p_earned, p_possible)
    ON CONFLICT (student_id, assessment_id)
  DO UPDATE SET
    points_earned   = EXCLUDED.points_earned,
             points_possible = EXCLUDED.points_possible,
             scored_at       = now();

SELECT course_id INTO v_course_id
FROM app.assessments
WHERE assessment_id = p_assessment_id;

-- Aggregate per assessment first to avoid double counting, then weight and scale to %
RETURN QUERY
    WITH per_assessment AS (
    SELECT a.assessment_id,
           COALESCE(SUM(s.points_earned) / NULLIF(SUM(s.points_possible), 0), 0) AS ratio, -- 0..1
           a.weight_pct
    FROM app.assessments a
    LEFT JOIN app.scores s
      ON s.assessment_id = a.assessment_id
     AND s.student_id    = p_student_id
    WHERE a.course_id = v_course_id
    GROUP BY a.assessment_id, a.weight_pct
  )
SELECT ROUND(SUM(ratio * (weight_pct/100.0)) * 100.0, 2) AS course_grade_pct
FROM per_assessment;
END;
$$;

-- 2) Per-course progress for a student and term, with per-assessment aggregation
CREATE OR REPLACE FUNCTION app.usp_get_student_progress(p_student_id INT, p_term TEXT)
RETURNS TABLE (
  course_name TEXT,
  grade_pct NUMERIC
)
LANGUAGE sql
AS $$
WITH enroll AS (
  SELECT e.course_id
  FROM app.enrollments e
  WHERE e.student_id = p_student_id
    AND e.term = p_term
),
scores_agg AS (
  -- collapse to a single ratio per assessment for this student
  SELECT s.assessment_id,
         COALESCE(SUM(s.points_earned) / NULLIF(SUM(s.points_possible), 0), 0) AS ratio
  FROM app.scores s
  WHERE s.student_id = p_student_id
  GROUP BY s.assessment_id
),
per_course AS (
  SELECT a.course_id,
         SUM( COALESCE(sa.ratio, 0) * (a.weight_pct/100.0) ) * 100.0 AS pct
  FROM app.assessments a
  JOIN enroll e ON e.course_id = a.course_id
  LEFT JOIN scores_agg sa ON sa.assessment_id = a.assessment_id
  GROUP BY a.course_id
)
SELECT c.name AS course_name,
       ROUND(COALESCE(pc.pct, 0), 2) AS grade_pct
FROM enroll e
         JOIN app.courses c ON c.course_id = e.course_id
         LEFT JOIN per_course pc ON pc.course_id = e.course_id;
$$;

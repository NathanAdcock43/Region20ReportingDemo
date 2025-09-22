-- 1) Insert a score and return updated course percentage
CREATE OR REPLACE FUNCTION app.usp_record_score_and_course_pct(
  p_student_id INT,
  p_assessment_id INT,
  p_earned NUMERIC,
  p_possible NUMERIC
)
RETURNS TABLE (course_grade_pct NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO app.scores(student_id, assessment_id, points_earned, points_possible)
  VALUES (p_student_id, p_assessment_id, p_earned, p_possible);

  RETURN QUERY
  SELECT COALESCE(
           SUM((s.points_earned / NULLIF(s.points_possible,0)) * (a.weight_pct/100.0)) * 100.0
         , 0)
  FROM app.assessments a
  JOIN app.scores s ON s.assessment_id = a.assessment_id AND s.student_id = p_student_id
  WHERE a.course_id = (SELECT course_id FROM app.assessments WHERE assessment_id = p_assessment_id);
END;
$$;

-- 2) Per-course progress for a student and term
CREATE OR REPLACE FUNCTION app.usp_get_student_progress(p_student_id INT, p_term TEXT)
RETURNS TABLE (
  course_name TEXT,
  grade_pct NUMERIC
)
LANGUAGE sql
AS $$
WITH agg AS (
  SELECT e.course_id,
         SUM((s.points_earned / NULLIF(s.points_possible,0)) * (a.weight_pct/100.0)) * 100.0 AS pct
  FROM app.enrollments e
  JOIN app.assessments a ON a.course_id = e.course_id
  LEFT JOIN app.scores s ON s.assessment_id = a.assessment_id AND s.student_id = e.student_id
  WHERE e.student_id = p_student_id AND e.term = p_term
  GROUP BY e.course_id
)
SELECT c.name, COALESCE(agg.pct, 0)
FROM app.enrollments e
JOIN app.courses c ON c.course_id = e.course_id
LEFT JOIN agg ON agg.course_id = e.course_id
WHERE e.student_id = p_student_id AND e.term = p_term;
$$;
-- dedupe first
WITH ranked AS (
    SELECT score_id,
           ROW_NUMBER() OVER (
           PARTITION BY student_id, assessment_id
           ORDER BY scored_at DESC, score_id DESC
         ) AS rn
    FROM app.scores
)
DELETE FROM app.scores s
    USING ranked r
WHERE s.score_id = r.score_id
  AND r.rn > 1;

-- Add unique constraint ONLY if it doesn't already exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'uq_scores_student_assessment'
      AND conrelid = 'app.scores'::regclass
  ) THEN
ALTER TABLE app.scores
    ADD CONSTRAINT uq_scores_student_assessment
        UNIQUE (student_id, assessment_id);
END IF;
END $$;


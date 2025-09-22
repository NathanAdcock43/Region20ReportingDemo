INSERT INTO app.students (first_name, last_name) VALUES
                                                     ('Alan','Turing'),
                                                     ('Grace','Hopper'),
                                                     ('Edsger','Dijkstra'),
                                                     ('Barbara','Liskov'),
                                                     ('Donald','Knuth');

INSERT INTO app.courses (name) VALUES
                                   ('Geometry'),
                                   ('Calculus');

INSERT INTO app.enrollments (student_id, course_id, term) VALUES
                                                              (2, 1, '2025-Fall'),  -- Alan in Algebra I
                                                              (3, 2, '2025-Fall'),  -- Grace in Geometry
                                                              (4, 2, '2025-Fall'),  -- Edsger in Geometry
                                                              (5, 3, '2025-Fall'),  -- Barbara in Calculus
                                                              (6, 3, '2025-Fall');  -- Donald in Calculus

-- Add assessments (weights total 100 per course)
-- Geometry
INSERT INTO app.assessments (course_id, name, weight_pct) VALUES
                                                              (2,'Homework',20.0),
                                                              (2,'Quiz',30.0),
                                                              (2,'Exam',50.0);

-- Calculus
INSERT INTO app.assessments (course_id, name, weight_pct) VALUES
                                                              (3,'Homework',25.0),
                                                              (3,'Quiz',25.0),
                                                              (3,'Midterm',25.0),
                                                              (3,'Final',25.0);

INSERT INTO app.scores (assessment_id, student_id, points_earned, points_possible) VALUES
                                                                                       -- Alan in Algebra I (new scores)
                                                                                       (1, 2, 85, 100),
                                                                                       (2, 2, 75, 100),
                                                                                       (3, 2, 90, 100),

                                                                                       -- Grace in Geometry
                                                                                       (4, 3, 88, 100),
                                                                                       (5, 3, 92, 100),
                                                                                       (6, 3, 95, 100),

                                                                                       -- Edsger in Geometry
                                                                                       (4, 4, 70, 100),
                                                                                       (5, 4, 80, 100),
                                                                                       (6, 4, 85, 100),

                                                                                       -- Barbara in Calculus
                                                                                       (7, 5, 90, 100),
                                                                                       (8, 5, 85, 100),
                                                                                       (9, 5, 80, 100),
                                                                                       (10,5, 95, 100),

                                                                                       -- Donald in Calculus
                                                                                       (7, 6, 75, 100),
                                                                                       (8, 6, 70, 100),
                                                                                       (9, 6, 65, 100),
                                                                                       (10,6, 80, 100);

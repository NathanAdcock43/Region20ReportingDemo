INSERT INTO app.students(first_name, last_name) VALUES ('Ada','Lovelace');
INSERT INTO app.courses(name) VALUES ('Algebra I');

-- One term, one enrollment, three assessments with simple weights
INSERT INTO app.enrollments(student_id, course_id, term)
VALUES (1, 1, '2025-Fall');

INSERT INTO app.assessments(course_id, name, weight_pct) VALUES
                                                             (1,'HW',20.0),
                                                             (1,'Quiz',30.0),
                                                             (1,'Exam',50.0);

INSERT INTO app.scores(assessment_id, student_id, points_earned, points_possible) VALUES
                                                                                      (1, 1, 80, 100),
                                                                                      (2, 1, 70, 100);

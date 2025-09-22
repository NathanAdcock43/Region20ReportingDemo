package com.nathan.region20reportingdemo.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
public class ProgressService {

    private final JdbcTemplate jdbc;

    public ProgressService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Map<String, Object>> getStudentProgress(int studentId, String term) {
        return jdbc.queryForList(
                "SELECT * FROM app.usp_get_student_progress(?, ?)",
                studentId, term
        );
    }

    public Map<String, Object> recordScoreAndCoursePct(int studentId, int assessmentId,
                                                       BigDecimal earned, BigDecimal possible) {
        return jdbc.queryForMap(
                "SELECT * FROM app.usp_record_score_and_course_pct(?, ?, ?, ?)",
                studentId, assessmentId, earned, possible
        );
    }


}

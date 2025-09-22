package com.nathan.region20reportingdemo.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

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


}

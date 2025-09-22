package com.nathan.region20reportingdemo.controller;


import com.nathan.region20reportingdemo.service.ProgressService;
import org.springframework.web.bind.annotation.*;


import java.math.BigDecimal;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/region20")
public class ProgressController {
    private final ProgressService svc;
    public ProgressController(ProgressService svc) { this.svc = svc; }


    @GetMapping("/progress/{studentId}")
    public List<Map<String,Object>> progress(@PathVariable int studentId, @RequestParam String term) {
        return svc.getStudentProgress(studentId, term);
    }

    @PostMapping("/score")
    public Map<String, Object> record(
            @RequestParam int studentId,
            @RequestParam int assessmentId,
            @RequestParam BigDecimal earned,
            @RequestParam BigDecimal possible) {
        return svc.recordScoreAndCoursePct(studentId, assessmentId, earned, possible);
    }


}

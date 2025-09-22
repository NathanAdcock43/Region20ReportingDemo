package com.nathan.region20reportingdemo.controller;


import com.nathan.region20reportingdemo.service.ProgressService;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api")
public class ProgressController {
    private final ProgressService svc;
    public ProgressController(ProgressService svc) { this.svc = svc; }


    @GetMapping("/progress/{studentId}")
    public List<Map<String,Object>> progress(@PathVariable int studentId, @RequestParam String term) {
        return svc.getStudentProgress(studentId, term);
    }


}

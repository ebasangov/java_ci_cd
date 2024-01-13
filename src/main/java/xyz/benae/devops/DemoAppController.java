package xyz.benae.devops;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoAppController {

    @GetMapping("/")
    public String hello() {
        return "Hello, Spring Boot!";
    }
}

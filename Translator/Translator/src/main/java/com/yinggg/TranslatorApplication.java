package com.yinggg;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@ComponentScan(basePackages = "com.yinggg.translator.Config")
@ComponentScan(basePackages = "com.yinggg.translator.utils")
@SpringBootApplication
public class TranslatorApplication {
    public static void main(String[] args) {
        SpringApplication.run(TranslatorApplication.class, args);


    }
}

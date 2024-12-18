package com.yinggg.translator.Config;

import com.yinggg.translator.Interceptor.LoginCheckInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Order(1)//设置拦截器执行顺序为1，使其优先执行
@Configuration //配置类
public class WebConfig implements WebMvcConfigurer {

//    @Autowired
//    private LoginCheckInterceptor loginCheckInterceptor;
//
//    @Override
//    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(loginCheckInterceptor)
//                        .addPathPatterns("/**")
//                        .excludePathPatterns("/login","/api","register");
//    }
}

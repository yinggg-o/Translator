package com.yinggg.translator.Controller;

import com.yinggg.translator.entity.SearchRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SearchController {

//    @GetMapping("/search")
    public String search(@RequestBody SearchRequest searchRequest) {

        // 通过searchRequest对象获取各个查询参数，进行搜索逻辑处理
//        String keyword1 = searchRequest.getKeyword1();
//        String keyword2 = searchRequest.getKeyword2();
//        String keyword3 = searchRequest.getKeyword3();
//        int page = searchRequest.getPage();
//        int size = searchRequest.getSize();

        return "搜索结果";
    }
}

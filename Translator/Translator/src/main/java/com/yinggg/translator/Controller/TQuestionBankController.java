package com.yinggg.translator.Controller;

import com.yinggg.translator.entity.TQuestionBank;
import com.yinggg.translator.service.impl.TQuestionBankServiceImpl;
import com.yinggg.translator.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;

@RestController

public class TQuestionBankController {
    @Autowired
    TQuestionBankServiceImpl tQuestionBankService;
    @GetMapping("/getArticleByBelong")
    public Result getArticleByBelong(@RequestParam("belong") String belong,
                                     @RequestParam("userId") String userId){

        if(belong.isEmpty() || userId.isEmpty()){
            return Result.error("参数错误");
        }
        ArrayList<TQuestionBank> articleByBelong = tQuestionBankService.getArticleByBelong(belong,userId);
        if (articleByBelong.isEmpty()) {
           return Result.error("没查询到相应数据");
        }
        return Result.success(articleByBelong);
    }

    /**
     * 用户确认后上传数据库 前端请求数据为 id 英文 和 中文
     * 请求路径/uploadText
     */
}

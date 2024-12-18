package com.yinggg.translator.Controller;

import cn.hutool.core.lang.Dict;
import cn.hutool.json.JSONUtil;
import com.yinggg.translator.utils.QFanApiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;

@RestController
@RequestMapping("/api")
public class QFanController {
    @Autowired
    QFanApiUtil qFanApiUtil;

    /**
     * 千帆模型api
     * @param content
     * @return
     */
    @GetMapping("/QFan")
    public Dict QF(@RequestParam("content") String content) {

        ArrayList param = new ArrayList();
        param.add(JSONUtil.createObj().set("role", "user").set("content", content));
        Dict dict = qFanApiUtil.commonReq(param);
        return dict;
    }
}

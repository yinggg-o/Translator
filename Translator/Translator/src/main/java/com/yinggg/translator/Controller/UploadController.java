
package com.yinggg.translator.Controller;

import com.yinggg.translator.entity.TQuestionBank;
import com.yinggg.translator.entity.TUser;
import com.yinggg.translator.service.TQuestionBankService;
import com.yinggg.translator.service.impl.TQuestionBankServiceImpl;
import com.yinggg.translator.utils.Result;

import java.io.IOException;
import java.util.List;
import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@CrossOrigin
@RestController
public class UploadController {
    @Resource
    private TQuestionBankServiceImpl uploadServiceImpl;


    /**
     *
     * 用户上传文件 将文件里的文字识别返回前端由用户确认
     *  解析文章
     *
     *
     */
    @PostMapping("/fetchtext")
    public Result upload(@RequestParam("file") MultipartFile file,
                         @RequestParam("userId") String userId) throws IOException {
        TUser tuser = new TUser();
        tuser.setId(Integer.valueOf(userId));
        List<String[]> data = null;
        try {
            data = this.uploadServiceImpl.upload(file, tuser.getId());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        if (data.isEmpty()) {
            Result.error("上传失败");
        }

        return  Result.success(data);

    }


    @PostMapping("/uploadText")
    public Result uploadText(@RequestBody TQuestionBank tUsers) {
        log.info("接收到的数据为：{}", tUsers);
        boolean success =  uploadServiceImpl.addQustion(tUsers);
        return Result.success();
    }


}

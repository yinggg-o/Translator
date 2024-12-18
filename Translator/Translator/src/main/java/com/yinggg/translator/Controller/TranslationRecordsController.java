package com.yinggg.translator.Controller;

import cn.hutool.core.util.ArrayUtil;
import com.yinggg.translator.entity.SearchRequest;
import com.yinggg.translator.entity.TTranslationRecords;
import com.yinggg.translator.service.impl.TTranslationRecordsServiceImpl;
import com.yinggg.translator.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;

@RestController
@RequestMapping("/translation")
public class TranslationRecordsController {
    @Autowired
    TTranslationRecordsServiceImpl tTranslationRecordsService;

    /*=================================== search方法开始 ===================================*/

    /**
     * @API /history/search 用户搜查错题
     * @param searchRequest
     * @return
     */
    @PostMapping("/history/search")
    public Result search(@RequestBody SearchRequest searchRequest) {
        int page = searchRequest.getPage();
        int size = searchRequest.getSize();

        // 确保page值最小为1，避免出现负数偏移量等问题
        if (page < 1) {
            page = 1;
        }

        // 直接计算偏移量并设置到searchRequest中
        searchRequest.setPage((page - 1) * size);

        Logger logger = LoggerFactory.getLogger(TranslationRecordsController.class);

        try {
            ArrayList<TTranslationRecords> result = tTranslationRecordsService.queryHistoryByUserIdOrOrigOrTran(searchRequest);
            System.out.println(ArrayUtil.toString(result));
            if (result.isEmpty()) {
                return Result.error("没搜索到相应记录");
            }
            return Result.success(result);
        } catch (Exception e) {
            // 记录详细的异常日志到文件等，根据具体配置而定
            logger.error("搜索过程中出现异常", e);

            return Result.error("搜索过程中出现异常，请稍后再试");
        }
    }
    /*=================================== search方法结束 ===================================*/

    /**
     * 先保留
     * @API /history 获取错题
     * @param tTranslationRecords
     * @return
     */
    /*=================================== history方法开始 ===================================*/
    @PostMapping("/history")
    public Result history(@RequestBody TTranslationRecords tTranslationRecords) {
//        System.out.println(tTranslationRecords.toString());
//        ArrayList<TTranslationRecords> result = tTranslationRecordsService.queryHistoryByUserIdOrOrigOrTran(tTranslationRecords);
//        if (result.isEmpty()) {
//            return Result.error("获取历史记录失败");
//        }
//
//        return Result.success(result);
        return Result.success("获取历史记录失败");
    }
    /*=================================== history方法结束 ===================================*/

    /**
     * @API /history/addTranslate 添加错题记录
     * @param tTranslationRecords
     * @return
     */
    /*=================================== addTranslate方法开始 ===================================*/
    @PostMapping("/history/addTranslate")
    public Result addTranslate(@RequestBody TTranslationRecords tTranslationRecords) {
        int result = tTranslationRecordsService.addTranslate(tTranslationRecords);
        if (result == 0) {
            return Result.error("添加失败");
        }
        return Result.success("添加成功");
    }

    /*=================================== addTranslate方法结束 ===================================*/

    /**
     * @param tTranslationRecords
     * @return
     * @API /history/update 用于更新错题记录
     */
    /*=================================== updateTranslate方法开始 ===================================*/

    @PostMapping("/history/update")
    public Result updateTranslate(@RequestBody TTranslationRecords tTranslationRecords) {
        int result = tTranslationRecordsService.updateTranslate(tTranslationRecords);
        if (result == 0) {
            return Result.error("更新失败");
        }
        return Result.success("更新成功");
    }

    /*=================================== updateTranslate方法结束 ===================================*/

    /**
     * @API /history/delete  删除错题记录
     * @param id
     * @return
     */
    @PostMapping("/history/delete")
    /*=================================== deleteTranslate方法开始 ===================================*/
    public Result deleteTranslate(@RequestParam("id") Integer id) {
        int result = tTranslationRecordsService.deleteTranslate(id);
        if (result == 0) {
            return Result.error("删除失败");
        }
        return Result.success("删除成功");
    }
    /*=================================== deleteTranslate方法结束 ===================================*/

}

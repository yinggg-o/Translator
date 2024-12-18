
package com.yinggg.translator.service.impl;

import com.yinggg.translator.entity.TQuestionBank;
import com.yinggg.translator.entity.TUser;
import com.yinggg.translator.mapper.TQuestionBankMapper;
import com.yinggg.translator.service.TQuestionBankService;
import com.yinggg.translator.utils.FileUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;

@Slf4j
@Service
public class TQuestionBankServiceImpl implements TQuestionBankService {

    @Autowired
    private TQuestionBankMapper TQuestionBankMapper;
    @Resource
    FileUtils fileUtils;


    /*=================================== upload方法开始 ===================================*/
    public ArrayList<String[]> upload(MultipartFile file, Integer userId) throws Exception {
        ArrayList<String[]> originalText = null;
        log.info(String.valueOf(userId));
        //判断文件不为空
        if (file == null || file.isEmpty()) {
            return new ArrayList<String[]>();
        }
        //判断文件名不为空
        String fileName = file.getOriginalFilename();
        if (fileName == null) {
            return new ArrayList<String[]>();
        }
        String suffixName = fileName.substring(fileName.lastIndexOf("."));

        //判断数据是否时 txt doc docx
        if (!(suffixName.equals(".txt") || suffixName.equals(".doc") || suffixName.equals(".docx"))) {
            return new ArrayList<String[]>();
        }
        //工具类不为空
        if (fileUtils == null) {
            throw new IllegalStateException("FileUtils is not initialized");
        }
        // 处理类型不同的文件
        if (suffixName.equals(".txt")) {
            System.out.println("开始处理文本文件....");
            originalText = fileUtils.TXTToText(file.getInputStream());
        } else {
            System.out.println("开始处理word文件....");
            originalText = fileUtils.WordToText(file.getInputStream());
        }
        log.info(String.valueOf(originalText));
        // 处理好的数据不为空
        if (originalText.isEmpty()) {
            return new ArrayList<String[]>();
        }
        String[] englishSentences = originalText.get(0);
        String[] chineseTranslations = originalText.get(1);

        // 原文和翻译长度不一致
        if (!(englishSentences.length == chineseTranslations.length)) {
            return new ArrayList<String[]>();
        }
        // 将英文句子和对应的中文翻译组合成数组添加到结果列表
        System.out.println("添加数据中...");
        System.out.println("文件名称:" + fileName);
        for (int i = 0; i < englishSentences.length; i++) {
            // 创建TQuestionBank对象并上传数据到数据库，添加异常处理
            try {
                System.out.println("==========================正在添加=======================");
                System.out.println("原文:" + englishSentences[i]);
                System.out.println("翻译:" + chineseTranslations[i]);
                TQuestionBank tQuestionBank = new TQuestionBank(0, englishSentences[i],
                        chineseTranslations[i], userId,
                        "", fileName);
                TQuestionBankMapper.addQuestion(tQuestionBank);
                System.out.println("添加成功");
            } catch (Exception e) {
                // 处理数据库操作异常，比如输出错误提示信息、记录日志等
                System.out.println("上传数据到数据库时出现异常：" + e.getMessage());
            }
        }

        return originalText;

    }
    /*=================================== upload 方法结束 ===================================*/
    /*=================================== getArticleByBelong 方法开始 ===================================*/

    @Override
    public ArrayList<TQuestionBank> getArticleByBelong(String belong, String userId) {

        return TQuestionBankMapper.getArticleByBelong(belong, userId);
    }

    @Override
    public  boolean addQustion(TQuestionBank tUsers) {
        try{
         int success =  TQuestionBankMapper.addQuestion(tUsers);
       if(success>0){
           return true;
       }
        }catch (Exception e){
            log.error(e.getMessage());
            return false ;

        }
        return false;
    }
    /*=================================== getArticleByBelong 方法结束 ===================================*/
}

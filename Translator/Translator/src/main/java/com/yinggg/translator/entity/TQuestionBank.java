package com.yinggg.translator.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
/**
 *    id; 句子唯一标识
 *    sourceText; 源语言句子
 *    targetText; 目标语言句子
 *    userId; 上传句子的用户id，关联用户表
 *    uploadTime; 句子上传时间
 *    belong; 该句字属于的篇文章
 */
public class TQuestionBank {
    private int id;
    private String sourceText;

    public TQuestionBank(String sourceText, String targetText, int userId, String belong) {
        this.sourceText = sourceText;
        this.targetText = targetText;
        this.userId = userId;
        this.belong = belong;
    }

    private String targetText;
    private int userId;
    private String uploadTime;
    private String belong;

}


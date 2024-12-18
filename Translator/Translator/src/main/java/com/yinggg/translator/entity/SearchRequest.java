package com.yinggg.translator.entity;

import lombok.Data;

/**
 * 用于搜索
 */
@Data
public class SearchRequest {
    private int userId;
    private String originalText;
    private String translatedText;
    private int page;
    private int size;

}

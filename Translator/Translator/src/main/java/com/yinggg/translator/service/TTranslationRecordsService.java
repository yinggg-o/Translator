package com.yinggg.translator.service;

import com.yinggg.translator.entity.SearchRequest;
import com.yinggg.translator.entity.TTranslationRecords;

import java.util.ArrayList;

public interface TTranslationRecordsService {
    /**
     * 用于搜索错题
     * @param searchRequest
     * @return ArrayList<TTranslationRecords>
     */
    ArrayList<TTranslationRecords> queryHistoryByUserIdOrOrigOrTran(SearchRequest searchRequest);

    /**
     * 用于添加错题
     * @param tTranslationRecords
     * @return 返回受影响的行数
     */
    int  addTranslate(TTranslationRecords tTranslationRecords);

    /**
     * 用于更新错题
     * @param tTranslationRecords
     * @return 返回受影响的行数
     */

    int updateTranslate(TTranslationRecords tTranslationRecords);

    /**
     * 用于删除错题
     * @param id
     * @return 返回受影响的行数
     */
    int deleteTranslate(Integer id);
}

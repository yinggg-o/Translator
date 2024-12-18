package com.yinggg.translator.mapper;

import com.yinggg.translator.entity.SearchRequest;
import com.yinggg.translator.entity.TTranslationRecords;
import org.apache.ibatis.annotations.Mapper;

import java.util.ArrayList;

@Mapper
public interface TTranslationRecordsMapper {

    /**
     * 查询所有错题记录
     * @return 实例对象
     */
    ArrayList<TTranslationRecords> queryHistoryByUserIdOrOrigOrTran(SearchRequest searchRequest);

    /**
     * 添加错词记录
     * @param tTranslationRecords 实体对象
     * @return 受影响的行数
     */
    int  addTranslate(TTranslationRecords tTranslationRecords);

    /**
     * 更新错题记录
     * @param tTranslationRecords 实体对象
     * @return 受影响的行数
     */
    int updateTranslate(TTranslationRecords tTranslationRecords);

    /**
     * 删除错题记录
     * @param id 删除id
     * @return 受影响的行数
     */
    int deleteTranslate(Integer id);
}

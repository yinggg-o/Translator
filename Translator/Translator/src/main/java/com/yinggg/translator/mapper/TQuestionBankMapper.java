
package com.yinggg.translator.mapper;

import com.yinggg.translator.entity.TQuestionBank;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.ArrayList;

@Mapper
public interface TQuestionBankMapper {

//    @Insert("INSERT INTO t_question_bank VALUES (default,#{sourceText},#{targetText},#{userId},now()))")
   int addQuestion(TQuestionBank tQuestionBank);

    ArrayList<TQuestionBank> getArticleByBelong(@Param("belong")String belong,
                                                @Param("userId")String userId);

}

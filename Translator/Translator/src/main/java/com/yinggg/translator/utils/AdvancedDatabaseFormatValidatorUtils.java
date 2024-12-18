package com.yinggg.translator.utils;

import com.yinggg.translator.Config.DataFormatValidatorFunction;
import com.yinggg.translator.entity.TTranslationRecords;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;
import java.util.function.Function;

/**
 * 这个类是用来检查数据是否符合要求的工具类
 */
public class AdvancedDatabaseFormatValidatorUtils {

    // 日期格式字符串，与数据库表中的日期格式对应
    private static final String DATE_FORMAT_STRING = "yyyy-MM-dd HH:mm:ss";

    // 验证整数格式的通用方法
    private static <T> boolean validateInteger(Optional<T> value, Function<T, String> mapper) {
        return value.map(mapper)
                .map(AdvancedDatabaseFormatValidatorUtils::isIntegerForDatabase)
                .orElse(false);
    }

    // 验证字符串非空且满足特定长度限制的通用方法（这里以varchar类型为例）
    private static <T> boolean validateStringWithLength(Optional<T> value, Function<T, String> mapper, int maxLength) {
        return value.map(mapper)
                .map(str -> str!= null &&!str.isEmpty() && str.length() <= maxLength)
                .orElse(false);
    }

    // 验证日期格式的通用方法
    private static <T> boolean validateDate(Optional<T> value, Function<T, String> mapper) {
        return value.map(mapper)
                .map(AdvancedDatabaseFormatValidatorUtils::isTranslationDateFormat)
                .orElse(false);
    }

    // 验证可空字符串格式的通用方法（只需判断非空即可）
    private static <T> boolean validateNullableString(Optional<T> value, Function<T, String> mapper) {
        return value.map(mapper)
                .map(str -> str == null ||!str.isEmpty())
                .orElse(true);
    }

    // 检测字符串是否符合数据库中的整数格式
    private static boolean isIntegerForDatabase(String str) {
        if (str == null) {
            return false;
        }
        try {
            Integer.parseInt(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // 检测字符串是否符合数据库中指定的日期格式
    private static boolean isTranslationDateFormat(String str) {
        if (str == null) {
            return false;
        }
        DateFormat sdf = new SimpleDateFormat(DATE_FORMAT_STRING);
        sdf.setLenient(false);
        try {
            Date date = sdf.parse(str);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // 具体到TTranslationRecords的id字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> ID_VALIDATOR =
            tTranslationRecords -> validateInteger(Optional.ofNullable(tTranslationRecords.getId()), Object::toString);

    // 具体到TTranslationRecords的user_id字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> USER_ID_VALIDATOR =
            tTranslationRecords -> validateInteger(Optional.ofNullable(tTranslationRecords.getUserId()), Object::toString);

    // 具体到TTranslationRecords的original_text字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> ORIGINAL_TEXT_VALIDATOR =
            tTranslationRecords -> validateStringWithLength(Optional.ofNullable(tTranslationRecords.getOriginalText()),
                    Object::toString, Integer.MAX_VALUE);

    // 具体到TTranslationRecords的translated_text字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> TRANSLATED_TEXT_VALIDATOR =
            tTranslationRecords -> validateStringWithLength(Optional.ofNullable(tTranslationRecords.getTranslatedText()),
                    Object::toString, Integer.MAX_VALUE);

    // 具体到TTranslationRecords的source_language字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> SOURCE_LANGUAGE_VALIDATOR =
            tTranslationRecords -> validateStringWithLength(Optional.ofNullable(tTranslationRecords.getSourceLanguage()),
                    Object::toString, 10);

    // 具体到TTranslationRecords的target_language字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> TARGET_LANGUAGE_VALIDATOR =
            tTranslationRecords -> validateStringWithLength(Optional.ofNullable(tTranslationRecords.getTargetLanguage()),
                    Object::toString, 10);

    // 具体到TTranslationRecords的translation_date字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> TRANSLATION_DATE_VALIDATOR =
            tTranslationRecords -> validateDate(Optional.ofNullable(tTranslationRecords.getTranslationDate()),
                    Object::toString);

    // 具体到TTranslationRecords的differences字段验证逻辑
    private static final DataFormatValidatorFunction<TTranslationRecords> DIFFERENCES_VALIDATOR =
            tTranslationRecords -> validateNullableString(Optional.ofNullable(tTranslationRecords.getDifferences()),
                    Object::toString);

    // 检查TTranslationRecords对象的数据格式是否符合数据库要求
    public static boolean validateDatabaseFormat(TTranslationRecords tTranslationRecords) {
        return ID_VALIDATOR.validate(tTranslationRecords)
                && USER_ID_VALIDATOR.validate(tTranslationRecords)
                && ORIGINAL_TEXT_VALIDATOR.validate(tTranslationRecords)
                && TRANSLATED_TEXT_VALIDATOR.validate(tTranslationRecords)
                && SOURCE_LANGUAGE_VALIDATOR.validate(tTranslationRecords)
                && TARGET_LANGUAGE_VALIDATOR.validate(tTranslationRecords)
                && TRANSLATION_DATE_VALIDATOR.validate(tTranslationRecords)
                && DIFFERENCES_VALIDATOR.validate(tTranslationRecords);
    }
}

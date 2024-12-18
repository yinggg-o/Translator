
package com.yinggg.translator.utils;

import java.io.*;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.alibaba.druid.util.StringUtils;
import com.yinggg.translator.entity.TQuestionBank;
import com.yinggg.translator.mapper.TQuestionBankMapper;
import org.apache.commons.io.IOUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;


@Component
public class FileUtils {

    @Autowired
    TQuestionBankMapper TQuestionBankMapper;

    /**
     * 处理Word文件
     * @param inputStream
     * @return 返回中英两个数组列表
     * @throws IOException
     */
    public ArrayList<String[]> WordToText(InputStream inputStream) throws Exception {
        XWPFDocument document = new XWPFDocument(inputStream);
        StringBuilder content = new StringBuilder();
        Iterator var4 = document.getParagraphs().iterator();

        while (var4.hasNext()) {
            XWPFParagraph paragraph = (XWPFParagraph) var4.next();
            content.append(paragraph.getText()).append("\n");
        }
        inputStream.close();
        return processDocument(content.toString());
    }

    /**
     * 处理文本文件
     * @param inputStream
     * @return 返回中英两个数组列表
     * @throws IOException
     */
    public ArrayList<String[]> TXTToText(InputStream inputStream) throws Exception {

        String content = new String(inputStream.readAllBytes(), "UTF-8");
        inputStream.close();
        return processDocument(content);

    }

    /**
     *  文本处理工具方法，用于将句子分段
     * @param content
     * @return 返回中英两个数组列表
     * @throws IOException
     * 暂时不能处理 原文和译文交替出现的情况，
     * 这种情况暂时可以用 QFan 大模型进行处理
     */
    public ArrayList<String[]> processDocument(String content) throws Exception {
        ArrayList<String[]> result = new ArrayList<>();

        // 先尝试按照"翻译："或"翻译:"分隔
        String[] contentSplitByTranslation = content.split("(翻译：|翻译:)");

        if (contentSplitByTranslation.length >= 2) {
            // 处理原始文本，去除两端空白字符并检查英文标点
            String originalText = containsEnglishPunctuation(contentSplitByTranslation[0].trim());
            // 处理翻译文本，去除两端空白字符并检查中文标点
            String translatedText = containsChinesePunctuation(contentSplitByTranslation[1].trim());

            // 用于临时存储英文句子和对应的中文翻译
            String[] englishSentences = originalText.split("-----");
            String[] chineseTranslations = translatedText.split("-----");

            result.add(englishSentences);
            result.add(chineseTranslations);
        } else {
            // 如果没有按照"翻译："或"翻译:"分隔成功，尝试通过判断中文出现位置来划分
            int chineseStartIndex = findChineseStartIndex(content);

            if (chineseStartIndex!= -1) {
                String originalText = containsEnglishPunctuation(content.substring(0, chineseStartIndex).trim());
                String translatedText = containsChinesePunctuation(content.substring(chineseStartIndex).trim());

                String[] englishSentences = originalText.split("-----");
                String[] chineseTranslations = translatedText.split("-----");

                result.add(englishSentences);
                result.add(chineseTranslations);
            } else {
                // 如果还是无法正确划分，输出错误提示信息
                System.out.println("文件内容无法正确划分中英文部分，请检查文件内容。");
            }
        }

        return result;
    }

    // 查找字符串中首次出现中文字符的索引
    private static int findChineseStartIndex(String str) throws Exception {
        for (int i = 0; i < str.length(); i++) {
            if (isContainChinese(str.substring(i, i + 1))) {
                return i;
            }
        }
        return -1;
    }

    // 处理字符串包含常见英文标点符号
    private static String containsEnglishPunctuation(String str) {
        return str.replaceAll("[\n\t\r]", "")
                .replaceAll("[.;?!\"'()]", "-----");
    }

    // 处理字符串包含常见中文标点符号
    private static String containsChinesePunctuation(String str) {
        return str.replaceAll("[\n\t\r]", "")
                .replaceAll("[。！；？]", "-----");
    }

    /**
     * 字符串是否包含中文
     *
     * @param str 待校验字符串
     * @return true 包含中文字符 false 不包含中文字符
     * @throws Exception
     */
    public static boolean isContainChinese(String str) throws Exception {

        if (StringUtils.isEmpty(str)) {
            throw new Exception("sms context is empty!");
        }
        Pattern p = Pattern.compile("[\u4E00-\u9FA5|\\！|\\，|\\。|\\（|\\）|\\《|\\》|\\“|\\”|\\？|\\：|\\；|\\【|\\】]");
        Matcher m = p.matcher(str);
        return m.find();
    }

}

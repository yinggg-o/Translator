package com.yinggg.translator.utils;

import org.jasypt.encryption.StringEncryptor;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 用于配置文件的加密解密
 * 加密需加ENC(加密后密钥）
 */
@Component
public class JasyptUtils {
    private static Logger logger = LoggerFactory.getLogger(JasyptUtils.class);

    @Autowired
    StringEncryptor encryptor;

    // 加密
    public String getEncryptResult(String string) {
        String encryptResult = encryptor.encrypt(string);
        logger.info("原字符串：{} ,加密后字符串: {}",string,encryptResult);
        return encryptResult;
    }

    // 解密
    public String getDecryptResult(String string) {
        String decryptResult = encryptor.decrypt(string);
        logger.info("加密后字符串：{} ,原字符串: {}",string,decryptResult);
        return decryptResult;
    }

    public static void main(String[] args) {
        StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
        encryptor.setPassword("yinggg"); // 相当于密钥加盐，这个要和配置文件一致
        String string="2aq47lpG3Pj3knvFsK8Etdke2nfm8Rg8";
        String encryptResult = encryptor.encrypt(string);
        logger.info("原字符串：{} ,加密后字符串: {}",string,encryptResult);

//        String string2="TfIU6YAvWUOXzylBSrm32zPKDUsY15nm9qJa77R+Y/+SdI6ZLsjR9w==";
//        String decryptResult = encryptor.decrypt(string2);
//        logger.info("加密后字符串：{} ,原字符串: {}",string2,decryptResult);
    }
}


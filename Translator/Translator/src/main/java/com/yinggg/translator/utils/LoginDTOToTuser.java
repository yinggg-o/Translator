package com.yinggg.translator.utils;

import com.yinggg.translator.entity.LoginDTO;
import com.yinggg.translator.entity.TUser;
import org.springframework.stereotype.Component;

/**
 * 用于将LoginDTO转换为TUser
 * Tuser 字段位加密后
 */
@Component
public class LoginDTOToTuser {

    public TUser convert(LoginDTO loginDTO) throws Exception {
       String AESUsername = EncryptionUtil.encrypt(loginDTO.getUsername());
       String AESpassword =  EncryptionUtil.encrypt(loginDTO.getPassword());
       TUser user =  new TUser(AESUsername,AESpassword);
       System.out.println(user);
        return user;

    }
    public LoginDTO convert(TUser tUser) throws Exception {
        String AESUsername = EncryptionUtil.decrypt(tUser.getUsername());
        String AESpassword =  EncryptionUtil.decrypt(tUser.getPassword());
    	LoginDTO loginDTO = new LoginDTO();
    	loginDTO.setUsername(AESUsername);
        loginDTO.setPassword(AESpassword);
    	return loginDTO;
    }

}

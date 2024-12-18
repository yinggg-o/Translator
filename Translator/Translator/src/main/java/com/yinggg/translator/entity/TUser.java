package com.yinggg.translator.entity;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * (TUser)实体类
 *
 * @author makejava
 * @since 2024-11-13 13:34:20
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class TUser implements Serializable {
    private Integer id;
    /**
     * 用户账户
     */
    private String username;
    /**
     * 用户密码
     */
    private String password;
    private String email;
    private String created_at;


    public TUser(String hashUsername, String hashPassword) {
        this.username = hashUsername;
        this.password = hashPassword;
    }
}


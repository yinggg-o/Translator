package com.yinggg.translator.service;

import com.aliyuncs.exceptions.ClientException;
import com.yinggg.translator.entity.LoginDTO;
import com.yinggg.translator.entity.TUser;
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.PageRequest;

/**
 * (TUser)表服务接口
 *
 * @author makejava
 * @since 2024-11-13 13:33:40
 */
public interface TUserService {

    /**
     * 通过ID查询单条数据
     *
     * @param username 主键
     * @return 实例对象
     */
    TUser queryById(String username);

    /**
     * 分页查询
     *
     * @param tUser 筛选条件
     * @param pageRequest      分页对象
     * @return 查询结果
     */
    // Page<TUser> queryByPage(TUser tUser, PageRequest pageRequest);

    /**
     * 新增数据
     *
     * @param tUser 实例对象
     * @return 实例对象
     */
    TUser insert(TUser tUser);

    /**
     * 修改数据
     *
     * @param tUser 实例对象
     * @return 实例对象
     */
    TUser update(TUser tUser);

    /**
     * 通过主键删除数据
     *
     * @param id 主键
     * @return 是否成功
     */
    boolean deleteById(Integer id);

   TUser login(LoginDTO tuser) throws Exception;

    boolean register(LoginDTO loginDTO) throws Exception;

    String SMSLogin(String tel) throws ClientException;

    boolean updatePassWord( LoginDTO loginDTO) throws Exception;
}

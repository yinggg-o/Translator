package com.yinggg.translator.service.impl;

import cn.hutool.core.util.ArrayUtil;
import com.aliyuncs.exceptions.ClientException;
import com.yinggg.translator.entity.LoginDTO;
import com.yinggg.translator.entity.TUser;
import com.yinggg.translator.mapper.TUserMapper;
import com.yinggg.translator.service.TUserService;
import com.yinggg.translator.utils.AliyunSMS;
import com.yinggg.translator.utils.GenerateCode;
import com.yinggg.translator.utils.LoginDTOToTuser;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.util.List;




/**
 * (TUser)表服务实现类
 *
 * @author makejava
 * @since 2024-11-13 13:33:40
 */
@Slf4j
@Service("tUserService")
public class TUserServiceImpl implements TUserService {
    @Resource
    private TUserMapper tUserMapper;
    @Resource
    private AliyunSMS aliyunSMS;

    @Resource
    private LoginDTOToTuser loginDTOToTuser;




    /**
     * 通过ID查询单条数据
     *
     * @param username 主键
     * @return 实例对象
     */
    @Override
    public TUser queryById(String username) {
        return this.tUserMapper.queryById(username);
    }

    /**
     * 分页查询
     *
     * @param tUser 筛选条件
     * @param pageRequest      分页对象
     * @return 查询结果
     */
//    @Override
//    public Page<TUser> queryByPage(TUser tUser, PageRequest pageRequest) {
//        long total = this.tUserDao.count(tUser);
//        return new PageImpl<>(this.tUserDao.queryAllByLimit(tUser, pageRequest), pageRequest, total);
//    }

    /**
     * 新增数据
     *
     * @param tUser 实例对象
     * @return 实例对象
     */
    @Override
    public TUser insert(TUser tUser) {
        this.tUserMapper.insert(tUser);
        return tUser;
    }

    /**
     * 修改数据
     *
     * @param tUser 实例对象
     * @return 实例对象
     */
    @Override
    public TUser update(TUser tUser) {
        this.tUserMapper.update(tUser);
        return this.queryById(tUser.getUsername());
    }

    /**
     * 通过主键删除数据
     *
     * @param id 主键
     * @return 是否成功
     */
    @Override
    public boolean deleteById(Integer id) {
        return this.tUserMapper.deleteById(id) > 0;
    }

    @Override
    public TUser login(LoginDTO loginDTO) throws Exception {
       TUser tUser = loginDTOToTuser.convert(loginDTO);
        return tUserMapper.login(tUser);
    }

    @Override
    public boolean register(LoginDTO loginDTO) throws Exception {
        TUser tUser = loginDTOToTuser.convert(loginDTO);
        System.out.println(tUser.toString());
        List<TUser> result = tUserMapper.queryByName(tUser.getUsername());
        System.out.println(ArrayUtil.toString(result));
        if (!result.isEmpty()) {
            // 如果用户名已存在，返回 false
            return false;
        }
        tUserMapper.insert(tUser);
        return true;
    }


    @Override
    public String SMSLogin(String tel) throws ClientException {
           String code = GenerateCode.generateVerifyCode(6);

          log.info("信息结果",aliyunSMS.sendSms(tel, code)); ;
            return code;

    }

    @Override
    public boolean updatePassWord(LoginDTO loginDTO) throws Exception {
        TUser tUser = loginDTOToTuser.convert(loginDTO);
        List<TUser> result = tUserMapper.queryByName(tUser.getUsername());
        if (!result.isEmpty()) {
            // 如果用户名已存在，返回 false
            return tUserMapper.updatePassWord(tUser) > 0;
        }return false;


    }
}

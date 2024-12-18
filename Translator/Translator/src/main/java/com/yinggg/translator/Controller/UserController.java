package com.yinggg.translator.Controller;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.captcha.CaptchaUtil;
import cn.hutool.captcha.LineCaptcha;
import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import com.aliyuncs.exceptions.ClientException;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.google.common.base.Preconditions;
import com.yinggg.translator.entity.LoginDTO;
import com.yinggg.translator.entity.TUser;
import com.yinggg.translator.service.TUserService;
import com.yinggg.translator.utils.JwtUtils;
import com.yinggg.translator.utils.Result;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@CrossOrigin
@RestController
public class UserController {
    @Resource
    private TUserService tUserService;
    @Autowired
    RedisTemplate redisTemplate;

    /**
     * 接受username 和password字段
     * json请求方式
     */
    @PostMapping("/login")
    public Result login(@RequestBody LoginDTO loginDTO) throws Exception {
        System.out.println(loginDTO);
        // guava参数校验
        Preconditions.checkNotNull(loginDTO.getUsername(), "账号不能为空");
        Preconditions.checkNotNull(loginDTO.getPassword(), "密码不能为空");
        Preconditions.checkNotNull(loginDTO.getImgcode(), "验证码不能为空");
        Preconditions.checkNotNull(loginDTO.getUuid(), "UUID不能为空");
        // 验证图形验证码
        String captchaKey = loginDTO.getUuid();
        String imgCodeFromFrontend = loginDTO.getImgcode();

        if (StrUtil.isBlank(captchaKey) || StrUtil.isBlank(imgCodeFromFrontend)) {
            return Result.error("图形验证码参数错误");
        }
        String imgcode = (String) redisTemplate.opsForHash().get(captchaKey, "code");
        if (imgcode == null || !imgcode.equals(imgCodeFromFrontend)) {
            return Result.error("图形验证码错误");
        }
        // 执行登录逻辑
        TUser user = tUserService.login(loginDTO);
        if (user != null) {
            // JWT令牌生成
            StpUtil.login(user.getId());
            Object token = StpUtil.getTokenInfo();
            // 将信息存到redis
            Map<String, Object> map = new HashMap<>();
            map.put("id", user.getId());
            map.put("username", user.getUsername());
            map.put("token", StpUtil.getTokenValue());
            redisTemplate.opsForHash().put("user", user.getId(), map);
            System.out.println(Result.success(token).toString());
            return Result.success(token);
        } else {
            return Result.error("登录失败");
        }
    }

    /**
     * 生成6位字母和数字组成的验证码
     */

    @GetMapping("/generateCaptcha")
    public Result generateCaptcha(HttpServletResponse response) throws IOException {
        // 使用Hutool的CaptchaUtil创建一个验证码对象，指定宽度、高度以及验证码长度
        LineCaptcha lineCaptcha = CaptchaUtil.createLineCaptcha(120, 40, 6, 5);
        // 获取验证码文本内容
        String ImgCode = lineCaptcha.getCode();
        // 生成一个唯一的键，用于在Redis中存储验证码
        String captchaKey = UUID.randomUUID().toString();

        // 设置响应头，指定内容类型为PNG图片格式，以便客户端能正确识别并展示图片
        response.setContentType(MediaType.IMAGE_PNG_VALUE);
        // 将验证码图片写入响应输出流，发送给客户端
        lineCaptcha.write(response.getOutputStream());
        // 创建一个Map用于存放验证码文本（后续可用于前端验证等）
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("captchaCode", ImgCode);
        // 将验证码文本存储到Redis中，使用生成的唯一键
        redisTemplate.opsForHash().put(captchaKey, "code", ImgCode);

        // 将生成的唯一键也返回给前端，以便后续验证时使用
        resultMap.put("captchaKey", captchaKey);

        // 返回包含验证码相关信息的响应实体，状态码设置为200表示成功
        return Result.success(resultMap);
    }


    /**
     * 手机登录生成验证码
     *
     * @return
     */
    @PostMapping("/smsCode")
    public Result smsLogin(String username) throws ClientException {
        String code = tUserService.SMSLogin(username);
        redisTemplate.opsForHash().put("code", username, code);
        return Result.success(code);
    }


    @PostMapping("/islogin")
    public Result isLogin() {
        System.out.println("Redis读取" + redisTemplate.opsForHash().get("user", 1));
        return Result.success(StpUtil.isLogin());
    }

    /**
     * 退出登录
     */
    @PostMapping("logout")
    public Result logout() {
        StpUtil.logout();
        return Result.success();
    }

    /**
     * 注册
     *
     * @param loginDTO
     * @return
     */
    @PostMapping("/register")
    public Result register(@RequestBody LoginDTO loginDTO) throws Exception {
        Preconditions.checkNotNull(loginDTO.getUsername(), "账号不能为空");
        Preconditions.checkNotNull(loginDTO.getPassword(), "密码不能为空");
        Preconditions.checkNotNull(loginDTO.getImgcode(), "验证码不能为空");
        Preconditions.checkNotNull(loginDTO.getUuid(), "UUID不能为空");
        Preconditions.checkNotNull(loginDTO.getSmscode(), "短信验证码不能为空");
        log.info(JSON.toJSONString(loginDTO));
        // 验证图形验证码
        String captchaKey = loginDTO.getUuid();
        String imgCodeFromFrontend = loginDTO.getImgcode();
        if (StrUtil.isBlank(captchaKey) || StrUtil.isBlank(imgCodeFromFrontend)) {
            return Result.error("验证码参数错误");
        }
        String imgcode = (String) redisTemplate.opsForHash().get(captchaKey, "code");
        if (imgcode == null || !imgcode.equals(imgCodeFromFrontend)) {
            return Result.error("图形验证码错误");
        }
        String code = (String) redisTemplate.opsForHash().get("code", loginDTO.getUsername());
        if (code == null || !code.equals(loginDTO.getSmscode().toUpperCase())) {
            return Result.error("短信验证码错误");
        }
        boolean success = tUserService.register(loginDTO);
        System.out.println(success);
        return success ? Result.success() : Result.error("账号已注册");
    }


    @PostMapping("/updatePassWord")
    public Result updatePassWord(@RequestBody LoginDTO loginDTO) throws Exception {
        Preconditions.checkNotNull(loginDTO.getUsername(), "账号不能为空");
        Preconditions.checkNotNull(loginDTO.getPassword(), "密码不能为空");
        Preconditions.checkNotNull(loginDTO.getImgcode(), "验证码不能为空");
        Preconditions.checkNotNull(loginDTO.getUuid(), "UUID不能为空");
        Preconditions.checkNotNull(loginDTO.getSmscode(), "短信验证码不能为空");
        log.info(JSON.toJSONString(loginDTO));
        // 验证图形验证码
        log.info(JSON.toJSONString(loginDTO));
        // 验证图形验证码
        String captchaKey = loginDTO.getUuid();
        String imgCodeFromFrontend = loginDTO.getImgcode();
        if (StrUtil.isBlank(captchaKey) || StrUtil.isBlank(imgCodeFromFrontend)) {
            return Result.error("验证码参数错误");
        }
        String imgcode = (String) redisTemplate.opsForHash().get(captchaKey, "code");
        if (imgcode == null || !imgcode.equals(imgCodeFromFrontend)) {
            return Result.error("图形验证码错误");
        }
        String code = (String) redisTemplate.opsForHash().get("code", loginDTO.getUsername());
        if (code == null || !code.equals(loginDTO.getSmscode())) {
            return Result.error("短信验证码错误");
        }

        boolean success = tUserService.updatePassWord(loginDTO);
        return null;
    }
}






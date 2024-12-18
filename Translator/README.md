以下是结合前后端的完整项目文档，包含了项目概述、技术栈、功能模块、数据库设计、API文档、前端说明、运行和使用指南，以及贡献指南。

# 项目文档

## 项目概述

该项目是一个翻译应用程序，提供多种翻译功能和用户管理功能。项目使用Spring Boot构建后端API，使用SwiftUI构建前端用户界面，旨在提供流畅的用户体验。

## 技术栈

### 后端

- **Spring Boot**：用于构建RESTful API。
- **MySQL**：作为数据库。
- **Redis**：用于缓存和存储验证码等临时数据。
- **JWT**：用于用户认证。
- **Swagger**：用于API文档。
- **Hutool**：用于工具类功能，如验证码生成。
- **阿里云短信服务**：用于发送短信验证码。

### 前端

- **SwiftUI**：用于构建用户界面。
- **Alamofire**：用于处理HTTP请求。
- **NavigationStack**：用于导航管理。

## 功能模块

### 1. 用户管理模块

#### 功能

- **注册**：用户可以通过输入用户名、密码、验证码和短信验证码进行注册。
- **登录**：用户可以通过输入用户名、密码和验证码进行登录。
- **重置密码**：用户可以通过输入相关信息重置密码。
- **退出登录**：用户可以安全退出应用。

#### 后端实现

- **数据库表**：`users`
  - `id` (INT, PRIMARY KEY, AUTO_INCREMENT): 用户ID
  - `username` (VARCHAR): 用户名
  - `password` (VARCHAR): 密码（加密存储）
  - `email` (VARCHAR): 邮箱
  - `phone` (VARCHAR): 手机号

- **API设计**：
  - **注册**：`/api/user/register`，`POST`方法，接收`username`、`password`、`imgcode`、`uuid`、`smscode`。
  - **登录**：`/api/user/login`，`POST`方法，接收`username`、`password`、`imgcode`、`uuid`。
  - **重置密码**：`/api/user/updatePassWord`，`POST`方法，接收`username`、`password`、`imgcode`、`uuid`、`smscode`。
  - **退出登录**：`/api/user/logout`，`POST`方法。

#### 前端实现

- **视图文件**：
  - `LoginView.swift`：提供用户登录、注册和重置密码的界面。
  - `RegisterView.swift`：提供用户注册界面。
  - `ResetPasswordView.swift`：提供用户重置密码界面。

- **交互流程**：
  - 用户在`LoginView`中输入用户名、密码和验证码，点击登录按钮，前端使用Alamofire发送请求到后端API。
  - 注册和重置密码的流程类似，用户输入相关信息后，前端发送请求到相应的API。

### 2. 翻译模块

#### 功能

- **文本翻译**：用户可以输入文本进行翻译，支持多种语言。
- **翻译结果展示**：翻译结果会在页面上展示。

#### 后端实现

- **数据库表**：`translation_records`
  - `id` (INT, PRIMARY KEY, AUTO_INCREMENT): 记录ID
  - `user_id` (INT, FOREIGN KEY): 用户ID
  - `original_text` (TEXT): 原文
  - `translated_text` (TEXT): 翻译后的文本
  - `timestamp` (TIMESTAMP): 翻译时间

- **API设计**：
  - **翻译文本**：`/api/qfan`，`GET`方法，接收`content`参数。

#### 前端实现

- **视图文件**：
  - `TranslateView.swift`：提供翻译功能，用户可以输入文本进行翻译。

- **交互流程**：
  - 用户在`TranslateView`中输入要翻译的文本，点击翻译按钮，前端使用Alamofire发送请求到后端API。
  - 翻译结果返回后，前端在页面上展示翻译结果。

### 3. 翻译记录模块

#### 功能

- **查看历史记录**：用户可以查看自己的翻译历史记录。
- **搜索记录**：用户可以根据条件搜索翻译记录。

#### 后端实现

- **API设计**：
  - **查看历史记录**：`/translation/history`，`POST`方法，接收`userId`。
  - **搜索记录**：`/translation/history/search`，`POST`方法，接收`userId`、`originalText`、`translatedText`、`page`、`size`。

#### 前端实现

- **视图文件**：
  - `WrongQuestionBookView.swift`：提供翻译对比卡片功能，用户可以查看翻译历史。

- **交互流程**：
  - 用户在`WrongQuestionBookView`中查看翻译历史，前端使用Alamofire发送请求到后端API获取数据。
  - 用户可以输入搜索条件，前端发送请求到搜索API，返回结果后在页面上展示。

### 4. 问题库模块

#### 功能

- **文章管理**：用户可以上传、搜索和展示文章。

#### 后端实现

- **数据库表**：`question_bank`
  - `id` (INT, PRIMARY KEY, AUTO_INCREMENT): 问题ID
  - `belong` (VARCHAR): 归属
  - `content` (TEXT): 问题内容
  - `user_id` (INT, FOREIGN KEY): 用户ID

- **API设计**：
  - **获取问题**：`/api/question/getArticleByBelong`，`GET`方法，接收`belong`、`userId`。

#### 前端实现

- **视图文件**：
  - `ArticleManagementView.swift`：提供文章管理功能，包括文章的上传、搜索和展示。

- **交互流程**：
  - 用户在`ArticleManagementView`中上传或搜索文章，前端使用Alamofire发送请求到后端API。
  - 返回的文章数据在页面上展示。

## API 文档

启动后端项目后，使用http:{ip:8081}/swagger-ui/index.html,查看所有api列表

### 用户管理 API

#### 登录

- **路径**: `/api/user/login`

- **方法**: `POST`

- **请求参数**:

  - `username` (String): 用户名
  - `password` (String): 密码
  - `imgcode` (String): 图形验证码
  - `uuid` (String): 验证码UUID

- **请求示例**:

  ```json
  {
    "username": "exampleUser",
    "password": "examplePassword",
    "imgcode": "abc123",
    "uuid": "unique-uuid-string"
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": {
        "userId": 1,
        "username": "exampleUser",
        "token": "jwt-token-string"
      }
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "登录失败"
    }
    ```

#### 注册

- **路径**: `/api/user/register`

- **方法**: `POST`

- **请求参数**:

  - `username` (String): 用户名
  - `password` (String): 密码
  - `imgcode` (String): 图形验证码
  - `uuid` (String): 验证码UUID
  - `smscode` (String): 短信验证码

- **请求示例**:

  ```json
  {
    "username": "newUser",
    "password": "newPassword",
    "imgcode": "abc123",
    "uuid": "unique-uuid-string",
    "smscode": "123456"
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "message": "注册成功"
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "账号已注册"
    }
    ```

#### 生成图形验证码

- **路径**: `/api/user/generateCaptcha`

- **方法**: `GET`

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": {
        "captchaCode": "abc123",
        "captchaKey": "unique-uuid-string"
      }
    }
    ```

#### 发送短信验证码

- **路径**: `/api/user/smsCode`

- **方法**: `POST`

- **请求参数**:

  - `username` (String): 用户名

- **请求示例**:

  ```json
  {
    "username": "exampleUser"
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": "123456"
    }
    ```

#### 检查登录状态

- **路径**: `/api/user/islogin`

- **方法**: `POST`

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": true
    }
    ```

#### 退出登录

- **路径**: `/api/user/logout`

- **方法**: `POST`

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "message": "退出成功"
    }
    ```

#### 更新密码

- **路径**: `/api/user/updatePassWord`

- **方法**: `POST`

- **请求参数**:

  - `username` (String): 用户名
  - `password` (String): 新密码
  - `imgcode` (String): 图形验证码
  - `uuid` (String): 验证码UUID
  - `smscode` (String): 短信验证码

- **请求示例**:

  ```json
  {
    "username": "exampleUser",
    "password": "newPassword",
    "imgcode": "abc123",
    "uuid": "unique-uuid-string",
    "smscode": "123456"
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "message": "密码更新成功"
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "更新失败"
    }
    ```

### 翻译 API

#### 翻译文本

- **路径**: `/api/qfan`

- **方法**: `GET`

- **请求参数**:

  - `content` (String): 要翻译的文本

- **请求示例**:

  ```
  /api/qfan?content=Hello
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": {
        "translatedText": "你好"
      }
    }
    ```

### 问题库 API

#### 获取问题

- **路径**: `/api/question/getArticleByBelong`

- **方法**: `GET`

- **请求参数**:

  - `belong` (String): 归属
  - `userId` (String): 用户ID

- **请求示例**:

  ```
  /api/question/getArticleByBelong?belong=math&userId=1
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": [
        {
          "id": 1,
          "content": "What is 2+2?"
        }
      ]
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "没查询到相应数据"
    }
    ```

### 文件上传 API

#### 上传文件

- **路径**: `/api/upload/fetchtext`

- **方法**: `POST`

- **请求参数**:

  - `file` (MultipartFile): 上传的文件
  - `userId` (String): 用户ID

- **请求示例**:

  - 使用表单数据上传文件

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": [
        ["text1", "text2"]
      ]
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "上传失败"
    }
    ```

#### 上传文本

- **路径**: `/api/upload/uploadText`

- **方法**: `POST`

- **请求参数**:

  - `tUsers` (TQuestionBank): 问题库对象

- **请求示例**:

  ```json
  {
    "id": 1,
    "english": "Hello",
    "chinese": "你好"
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "message": "上传成功"
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "上传失败"
    }
    ```

### 翻译记录 API

#### 搜索翻译记录

- **路径**: `/translation/history/search`

- **方法**: `POST`

- **请求参数**:

  - `userId` (int): 用户ID
  - `originalText` (String): 原文
  - `translatedText` (String): 翻译后的文本
  - `page` (int): 页码
  - `size` (int): 每页大小

- **请求示例**:

  ```json
  {
    "userId": 1,
    "originalText": "Hello",
    "translatedText": "你好",
    "page": 1,
    "size": 10
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": [
        {
          "id": 1,
          "originalText": "Hello",
          "translatedText": "你好"
        }
      ]
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "没搜索到相应记录"
    }
    ```

#### 获取翻译历史

- **路径**: `/translation/history`

- **方法**: `POST`

- **请求参数**:

  - `tTranslationRecords` (TTranslationRecords): 翻译记录对象

- **请求示例**:

  ```json
  {
    "userId": 1
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "data": [
        {
          "id": 1,
          "originalText": "Hello",
          "translatedText": "你好"
        }
      ]
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "获取历史记录失败"
    }
    ```

#### 添加翻译记录

- **路径**: `/translation/history/addTranslate`

- **方法**: `POST`

- **请求参数**:

  - `tTranslationRecords` (TTranslationRecords): 翻译记录对象

- **请求示例**:

  ```json
  {
    "userId": 1,
    "originalText": "Hello",
    "translatedText": "你好"
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "message": "添加成功"
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "添加失败"
    }
    ```

#### 更新翻译记录

- **路径**: `/translation/history/update`

- **方法**: `POST`

- **请求参数**:

  - `tTranslationRecords` (TTranslationRecords): 翻译记录对象

- **请求示例**:

  ```json
  {
    "id": 1,
    "originalText": "Hello",
    "translatedText": "你好"
  }
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "message": "更新成功"
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "更新失败"
    }
    ```

#### 删除翻译记录

- **路径**: `/translation/history/delete`

- **方法**: `POST`

- **请求参数**:

  - `id` (Integer): 翻译记录ID

- **请求示例**:

  ```
  /translation/history/delete?id=1
  ```

- **响应**:

  - 成功:

    ```json
    {
      "status": "success",
      "message": "删除成功"
    }
    ```

  - 失败:

    ```json
    {
      "status": "error",
      "message": "删除失败"
    }
    ```

## 运行和使用

### 后端

1. **环境准备**
   - 确保安装了JDK 11和Maven。

- 配置MySQL数据库，并导入项目提供的SQL脚本以创建数据库表。

  - 将配置文件信息进行修改

    - 1.在Utils目录下找到JasyUtils文件，在测试方法中将string变量的值改为需要加密的密钥

    - ```java
      public static void main(String[] args) {
          StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
          encryptor.setPassword("yinggg"); // 相当于密钥加盐，这个要和配置文件一致
          String string="需要加密的字符串";
          String encryptResult = encryptor.encrypt(string);
          logger.info("原字符串：{} ,加密后字符串: {}",string,encryptResult);
      ```

2. **项目构建**

- 使用Maven构建项目：`mvn clean install`。

3. **运行项目**

   - 运行Spring Boot应用：`mvn spring-boot:run`。

### 前端

1. **环境准备**
   - 确保安装了Xcode。
   - 请求地址需更改APIConfigView中的IP地址，方可正常使用后端服务
2. **安装依赖**
   - 在Xcode中打开项目，确保项目中已配置好所需的Swift包（如Alamofire）。
3. **启动项目**
   - 在Xcode中选择目标设备或模拟器，点击运行按钮启动应用。



## 项目问题汇总

### 一、视图文件功能异常

#### （一）WrongQuestionBookView 文件

##### 1. 数据展示问题



在 WrongQuestionBookView 文件中，存在数据展示问题，获取数据后无法在右边显示区域正常展示，影响了信息的呈现效果。

###### （1）问题影响



此问题影响了该部分功能所对应信息的呈现，导致数据展示不完整不准确。

###### （2）解决需求



需尽快解决以确保数据展示的准确性和完整性，保障该部分功能的正常使用。

#### （二）ArticleManagementView 文件

##### 1. 文章上传响应数据显示问题



在 ArticleManagementView 文件中，文章上传后响应的数据未能在右边显示区域展示。

###### （1）问题影响

使得用户无法及时获取上传操作的反馈信息，对业务流程的连贯性造成负面影响。

###### （2）解决需求

亟待修复以提升用户操作体验。

##### 2. 搜索接口未对接问题

该文件的搜索接口尚未完成对接。

###### （1）问题影响

​		导致搜索功能无法正常使用，限制了用户获取文章资源的便捷性。

###### （2）解决需求

​		需加快对接工作以完善此功能，满足用户需求。

### 二、用户提示缺失

### 1. 问题描述

​	整个项目在用户交互方面，缺乏有效的用户提示机制。

### 2. 问题影响

​	在用户执行各类操作，如数据提交、功能调用等过程中，未适时提供清晰明确的提示信息，易造成用户困惑。

### 3. 解决需求

​	应尽快完善用户提示功能，增强用户交互体验。

### 三、登录页安全漏洞

### 1. 问题描述

​	登录页存在密码未隐藏的情况。

### 2. 问题影响

​	这不符合安全隐私规范，存在用户密码被窥视的风险，严重影响用户账户安全。

### 3. 解决需求

​	需立即对登录页密码显示方式进行修改，确保用户信息安全。

### 四、页面美观性欠佳

#### 1. 问题描述

​	从整体页面视觉效果来看，当前页面设计美观程度不足。

#### 2. 问题影响

​	页面布局和色彩搭配未达到理想标准，可能影响用户对项目的第一印象和持续使用意愿。

#### 3. 解决需求

​	需对页面进行优化设计，提升页面美观度和用户体验。

## 贡献指南

欢迎贡献！请遵循以下步骤：

1. Fork 本项目。
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)。
3. 提交更改 (`git commit -m 'Add some amazing feature'`)。
4. 推送到分支 (`git push origin feature/AmazingFeature`)。
5. 创建 Pull Request。

## 许可证

本项目采用木兰宽松许可证，第2版，详细信息请参见 LICENSE 文件。


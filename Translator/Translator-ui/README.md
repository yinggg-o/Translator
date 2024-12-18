### 项目视图模块

#### 1. View 文件夹



- 1.1 ArticleManagementView.swift
  - **功能**：提供文章管理功能，包括文章的上传、搜索和展示。
  - 接口：
    - `uploadArticle()`：上传文章。
    - `searchArticles()`：搜索文章。
  - **已对接接口**：使用 Alamofire 与 API 对接进行文章搜索。
- 1.2 HomeView.swift
  - **功能**：应用程序的主界面，提供导航到不同功能视图的入口。
  - 接口：
    - `showTranslateView`，`showArticleManagementView`，`showWrongQuestionBookView`：控制不同视图的显示。
  - **已对接接口**：无。
- 1.3 LoginView.swift
  - **功能**：提供用户登录、注册和重置密码的界面。
  - 接口：
    - `checkLoginStatus()`：检查用户登录状态。
    - `login(with:)`：处理用户登录请求。
  - **已对接接口**：使用 Alamofire 与 API 对接进行用户登录。
- 1.4 NewPageView.swift
  - **功能**：提供短句搜索和展示功能。
  - **接口**：无。
  - **已对接接口**：无。
- 1.5 RegisterView.swift
  - **功能**：提供用户注册界面。
  - **接口**：无。
  - **已对接接口**：无。
- 1.6 ResetPasswordView.swift
  - **功能**：提供用户重置密码界面。
  - **接口**：无。
  - **已对接接口**：无。
- 1.7 TranslateView.swift
  - **功能**：提供翻译功能，用户可以输入文本进行翻译。
  - 接口：
    - `fetchArticles()`：获取文章数据。
    - `saveCurrentState()`，`loadPreviousState()`：保存和加载用户的学习状态。
  - **已对接接口**：使用 Alamofire 与 API 对接获取翻译数据。
- 1.8 WrongQuestionBookView.swift
  - **功能**：提供翻译对比卡片功能，用户可以查看翻译历史。
  - 接口：
    - `loadData()`，`clearData()`：加载和清空数据。
  - **已对接接口**：使用 Alamofire 与 API 对接获取翻译历史。

#### 2. Utils 文件夹



- 2.1 CaptchaManager.swift
  - **功能**：管理验证码的获取和处理。
  - 接口：
    - `getImageCode()`：获取验证码图片。
  - **已对接接口**：使用 Alamofire 与 API 对接获取验证码。
- 2.2 ClearButtonStyle.swift
  - **功能**：定义一个自定义的按钮样式。
  - **接口**：无。
  - **已对接接口**：无。

#### 3. ContentView.swift



- **功能**：定义应用程序的主视图 TranslatorView，根据用户的登录状态显示不同的视图（HomeView 或 LoginView）。
- **接口**：使用 `@EnvironmentObject` 注入 `UserLoginStatus`。
- **已对接接口**：无。

#### 4. TranslatorApp.swift



- **功能**：应用程序的入口，设置应用程序的主视图和环境对象。
- **接口**：无。
- **已对接接口**：无。

### 总结



项目的视图模块主要负责用户界面的展示和交互，使用 SwiftUI 构建。Utils 模块提供了辅助功能，如验证码管理和自定义按钮样式。ContentView.swift 和 TranslatorApp.swift 文件负责应用程序的主视图和入口设置。项目中部分视图（如 LoginView 和 TranslateView）通过 Alamofire 与 API 对接，实现数据的获取和提交。
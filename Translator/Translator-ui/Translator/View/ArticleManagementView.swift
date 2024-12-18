import SwiftUI
import Alamofire
import Foundation

// 直接使用 APIConfigManager.shared 的方法
let apiConfig = APIConfigManager.shared

// 文章数据结构
struct Article: Identifiable, Codable {
    let id: Int
    let title: String
    let sentences: [String]
}

struct ArticleSearchResponse: Codable {
    let articles: [Article]
    let totalPages: Int
}

struct UploadResponse: Codable {
    let code: Int
    let msg: String
    let data: [[String]]
}

struct ArticleManagementView: View {
    @State private var newArticleTitle: String = ""
    @State private var newArticleContent: String = ""
    @State private var searchText: String = ""
    @State private var articles: [Article] = []
    @State private var currentPage: Int = 1
    @State private var pageSize: Int = 10
    @State private var totalPages: Int = 1
    @State private var isLoading: Bool = false
    @State private var selectedArticle: Article? = nil
    @State private var currentSentenceIndex: Int = 0
    @State private var selectedFileURL: URL? // 用于存储选择的文件URL
    @State private var uploadResponse: [[String]] = [] // 用于���储响应数据

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Text("文章管理")
                        .font(.system(size: 24, weight: .bold))
                        .padding()

                    HStack(spacing: 0) {
                        VStack(spacing: 20) {
                            // 文章上传部分
                            VStack(alignment: .leading, spacing: 10) {
                                TextField("文章标题", text: $newArticleTitle)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color(NSColor.windowBackgroundColor))
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )

                                TextField("文章内容", text: $newArticleContent)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color(NSColor.windowBackgroundColor))
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )

                                Button(action: {
                                    if let fileURL = selectedFileURL {
                                        uploadFile(url: fileURL) // 上传文件并解析
                                    } else {
                                        print("请先选择一个文件")
                                    }
                                }) {
                                    Text("上传文章")
                                        .font(.system(size: 16, weight: .medium))
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(selectedFileURL == nil ? Color.gray.opacity(0.6) : Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                                .buttonStyle(ClearButtonStyle())
                                .disabled(selectedFileURL == nil)

                                // 文件上传部分
                                Button("选择文件") {
                                    // 选择文件
                                    let panel = NSOpenPanel()
                                    panel.canChooseFiles = true // 允许选择文件
                                    panel.canChooseDirectories = false // 不允许选择文件夹
                                    panel.allowedFileTypes = ["txt", "md", "doc", "docx"] // 允许的文件类型
                                    panel.begin { result in
                                        if result == .OK {
                                            self.selectedFileURL = panel.url // 获取选择的文件URL
                                        }
                                    }
                                }
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                            }
                            .padding()

                            // 文章搜索部分
                            VStack(alignment: .leading, spacing: 10) {
                                TextField("搜索文章", text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color(NSColor.windowBackgroundColor))
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )

                                Button(action: searchArticles) {
                                    Text("搜索")
                                        .font(.system(size: 16, weight: .medium))
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                                .buttonStyle(ClearButtonStyle())
                            }
                            .padding()
                        }
                        .frame(width: geometry.size.width * 0.35)
                        .background(Color(NSColor.controlBackgroundColor))

                        Divider()

                        // 文章列表展示及分页部分
                        VStack(spacing: 10) {
                            if let article = selectedArticle {
                                // 显示选中的文章内容
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(article.title)
                                            .font(.system(size: 20, weight: .bold))
                                            .padding(.bottom, 5)
                                        ForEach(currentPageSentences(article), id: \.self) { sentence in
                                            Text(sentence)
                                                .padding(.bottom, 2)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color(NSColor.windowBackgroundColor))
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                                HStack {
                                    Button(action: { selectedArticle = nil }) {
                                        Text("返回")
                                            .font(.system(size: 16, weight: .medium))
                                            .padding(8)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                    }
                                    .buttonStyle(ClearButtonStyle())
                                    .frame(height: 40)
                                }
                            } else {
                                // 显示文章卡片
                                List {
                                    ForEach(articles, id: \.id) { article in
                                        Button(action: { 
                                            selectedArticle = article
                                            currentPage = 1
                                            totalPages = (article.sentences.count + pageSize - 1) / pageSize
                                        }) {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(article.title)
                                                    .font(.system(size: 18, weight: .medium))
                                                    .padding(.bottom, 5)
                                                Text(article.sentences.joined(separator: " "))
                                                    .lineLimit(2)
                                                    .padding(.bottom, 2)
                                            }
                                            .padding()
                                            .background(Color(NSColor.windowBackgroundColor))
                                            .cornerRadius(8)
                                            .shadow(radius: 2)
                                            .frame(maxWidth: .infinity) // 卡片宽度铺满
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .listStyle(PlainListStyle())
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width * 0.65)

                        // 显示上传响应数据
                        VStack(alignment: .leading) {
                            Text("上传响应数据")
                                .font(.headline)
                                .padding(.bottom, 5)

                            List {
                                ForEach(uploadResponse, id: \.self) { responseArray in
                                    ForEach(responseArray, id: \.self) { response in
                                        Text(response)
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.35)
                    }
                }
            }
        }.frame(width:700,height:440)
    }

    func uploadArticle() {
        // 使用假数据替换 API 请求
        let newArticle = Article(id: articles.count + 1, title: newArticleTitle, sentences: [newArticleContent])
        articles.append(newArticle)
        newArticleTitle = ""
        newArticleContent = ""
    }

    func uploadFile(url: URL) {
        guard let loginId = UserDefaults.standard.string(forKey: "loginId") else {
            print("无法获取用户ID")
            return
        }
        print("获取到的用户ID: \(loginId)")
        
        let uploadURL = URL(string: APIConfigManager.shared.articleFetchText)!

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(url, withName: "file")
            multipartFormData.append(Data(loginId.utf8), withName: "userId")
        }, to: uploadURL).responseDecodable(of: UploadResponse.self) { response in
            switch response.result {
            case .success(let uploadResponseData):
                print("文件上传成功")
                print("响应数据: \(uploadResponseData.data)")
                uploadResponse = uploadResponseData.data
            case .failure(let error):
                print("文件上传失败: \(error)")
            }
        }
    }

    func uploadToDatabase(fileData: Data?) {
        let uploadURL = URL(string: APIConfigManager.shared.articleUploadText)!
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let loginId = UserDefaults.standard.object(forKey: "loginId") as? Int else {
            print("无法获取用户ID")
            return
        }

        let parameters: [String: Any] = [
            "data": String(data: fileData ?? Data(), encoding: .utf8) ?? "",
            "userId": loginId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        AF.request(uploadURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: ArticleSearchResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("数据上传成功")
                // 处理上传成功后的逻辑
            case .failure(let error):
                print("数据上传失败: \(error)")
            }
        }
    }

    func deleteArticle(_ id: Int) {
        // 使用假数据替换 API 请求
        articles.removeAll { $0.id == id }
    }

    func searchArticles() {
        isLoading = true
        let parameters: [String: String] = ["belong": "专升本", "userId": "1"]
        AF.request(APIConfigManager.shared.articleGetByBelong, method: .get, parameters: parameters).responseDecodable(of: ArticleSearchResponse.self) { response in
            isLoading = false
            switch response.result {
            case .success(let value):
                articles = value.articles
                totalPages = value.totalPages
            case .failure(let error):
                print("搜索文章失败: \(error)")
            }
        }
    }

    func currentPageSentences(_ article: Article) -> [String] {
        let start = (currentPage - 1) * pageSize
        let end = min(start + pageSize, article.sentences.count)
        return Array(article.sentences[start..<end])
    }
}

struct ArticleManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleManagementView()
    }
}

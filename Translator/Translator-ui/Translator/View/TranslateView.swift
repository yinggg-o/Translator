import SwiftUI
import Combine
import Alamofire

struct ArticleData: Identifiable, Decodable {
    let id: Int
    let sourceText: String
    let targetText: String
}

struct TranslationHistory: Decodable {
    let id: Int
    let userId: Int
    let originalText: String
    let translatedText: String
    let sourceLanguage: String
    let targetLanguage: String
    let translationDate: String
    let differences: String
}

struct TranslationHistoryResponse: Decodable {
    let code: Int
    let msg: String
    let data: [TranslationHistory]
}

class TranslateViewModel: ObservableObject {
    @Published var currentArticleIndex = 0
    @Published var articles: [ArticleData] = []
    @Published var userTranslation: String = ""
    @Published var showComparison: Bool = false
    @Published var currentSentencePosition: String = ""

    var hasNextArticle: Bool {
        return currentArticleIndex < articles.count - 1
    }

    var hasPreviousArticle: Bool {
        return currentArticleIndex > 0
    }

    init() {
        loadState()
    }

    func fetchArticles() {
        let url = APIConfigManager.shared.articleGetByBelong
        guard let userId = UserDefaults.standard.value(forKey: "loginId") as? Int else {
            print("无法获取用户ID")
            return
        }
        let parameters: [String: Any] = ["belong": "1", "userId": userId]

        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                DispatchQueue.main.async {
                    self.articles = apiResponse.data
                    self.updateSentencePosition()
                }
            case .failure(let error):
                print("Error fetching articles: \(error.localizedDescription)")
                if let data = response.data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
                }
            }
        }
    }

    func nextArticle() {
        if hasNextArticle {
            currentArticleIndex += 1
            resetTranslation()
            updateSentencePosition()
        }
    }

    func previousArticle() {
        if hasPreviousArticle {
            currentArticleIndex -= 1
            resetTranslation()
            updateSentencePosition()
        }
    }

    func resetTranslation() {
        userTranslation = ""
        showComparison = false
    }

    func updateSentencePosition() {
        currentSentencePosition = "第 \(currentArticleIndex + 1) 条，共 \(articles.count) 条"
    }

    func compareTranslation() -> Text {
        let correctTranslation = articles[safe: currentArticleIndex]?.sourceText ?? ""
        let userWords = userTranslation.split(separator: " ")
        let correctWords = correctTranslation.split(separator: " ")

        var result = Text("")
        var hasError = false

        for (index, correctWord) in correctWords.enumerated() {
            if index < userWords.count {
                let userWord = userWords[index]
                if userWord == correctWord {
                    result = result + Text(String(correctWord) + " ").foregroundColor(.green)
                } else {
                    result = result + Text(String(correctWord) + " ").foregroundColor(.red)
                    hasError = true
                }
            } else {
                result = result + Text(String(correctWord) + " ").foregroundColor(.red)
                hasError = true
            }
        }

        if userWords == correctWords {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextArticle()
            }
        } else if hasError {
            checkIfTranslationExists(originalText: correctTranslation, translatedText: articles[safe: currentArticleIndex]?.targetText ?? "")
        }

        return result
    }

    func checkIfTranslationExists(originalText: String, translatedText: String) {
        let url = APIConfigManager.shared.translationHistorySearch
        guard let userId = UserDefaults.standard.value(forKey: "loginId") as? Int else {
            print("无法获取用户ID")
            return
        }

        let parameters: [String: Any] = [
            "userId": userId,
            "page": 1,
            "size": 100
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: TranslationHistoryResponse.self) { response in
            switch response.result {
            case .success(let historyResponse):
                let exists = historyResponse.data.contains { $0.originalText == originalText && $0.translatedText == translatedText }
                if !exists {
                    self.sendErrorToAPI(originalText: originalText, translatedText: translatedText)
                } else {
                    print("翻译已存在，未重复添加")
                }
            case .failure(let error):
                print("检查翻译历史失败: \(error)")
            }
        }
    }

    func sendErrorToAPI(originalText: String, translatedText: String) {
        let url = APIConfigManager.shared.translationAddTranslate
        guard let userId = UserDefaults.standard.value(forKey: "loginId") as? Int else {
            print("无法获取用户ID")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: Date())

        let parameters: [String: Any] = [
            "id": 0,
            "userId": userId,
            "originalText": originalText,
            "translatedText": translatedText,
            "sourceLanguage": "英文",
            "targetLanguage": "中文",
            "translationDate": formattedDate,
            "differences": "翻译错误"
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                print("错误翻译已发送")
            case .failure(let error):
                print("发送错误翻译失败: \(error)")
            }
        }
    }

    func saveState() {
        UserDefaults.standard.set(currentArticleIndex, forKey: "currentArticleIndex")
    }

    func loadState() {
        if let savedIndex = UserDefaults.standard.value(forKey: "currentArticleIndex") as? Int {
            currentArticleIndex = savedIndex
        }
    }
}

struct APIResponse: Decodable {
    let code: Int
    let msg: String
    let data: [ArticleData]
}

struct TranslateView: View {
    @ObservedObject var viewModel = TranslateViewModel()

    var body: some View {
        VStack {
            if let article = viewModel.articles[safe: viewModel.currentArticleIndex] {
                Text(article.targetText)
                    .font(.title)
                    .padding()

                TextField("请输入译文...", text: $viewModel.userTranslation, onCommit: {
                    viewModel.showComparison = true
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if viewModel.showComparison {
                    viewModel.compareTranslation()
                        .padding()
                }

                Text(viewModel.currentSentencePosition)
                    .padding()
            } else {
                Text("No Article Available")
            }

            HStack {
                Button("上一句") {
                    viewModel.previousArticle()
                }
                .disabled(!viewModel.hasPreviousArticle)

                Button("下一句") {
                    viewModel.nextArticle()
                }
                .disabled(!viewModel.hasNextArticle)
            }
            .padding()
        }
        .frame(maxWidth: 800, maxHeight: 600)
        .padding()
        .onAppear {
            viewModel.fetchArticles()
        }
        .onDisappear {
            viewModel.saveState()
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView()
    }
}

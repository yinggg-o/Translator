import SwiftUI
import Alamofire
import Foundation
import Translator  // 添加模块导入


// 根据API响应修改后的BackendData结构体
struct BackendData: Identifiable, Codable {
    let id: Int
    let userId: Int
    let originalText: String
    let translatedText: String
    let sourceLanguage: String
    let targetLanguage: String
    let translationDate: String
    let differences: String
}

// 主视图，包含操作区和内容展示区
struct WrongQuestionBookView: View {
    @State private var backendData: [BackendData] = []
    @State private var isLoading: Bool = false
    @State private var searchText: String = ""

    var body: some View {
        HStack(spacing: 0) {
            // 左边操作区
            VStack(spacing: 20) {
                Text("翻译对比卡片")
                  .font(.system(size: 24, weight:.bold))
                  .padding()

                TextField("搜索", text: $searchText)
                  .textFieldStyle(PlainTextFieldStyle())
                  .padding(10)
                  .background(Color(NSColor.windowBackgroundColor))
                  .cornerRadius(6)
                  .overlay(
                        RoundedRectangle(cornerRadius: 6)
                          .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                Button(action: loadData) {
                    Text("搜索")
                      .font(.system(size: 16, weight:.medium))
                      .frame(maxWidth:.infinity)
                      .padding(8)
                      .background(Color.blue)
                      .foregroundColor(.white)
                      .cornerRadius(6)
                }
              .buttonStyle(ClearButtonStyle())

                Button(action: clearData) {
                    Text("清空数据")
                      .font(.system(size: 16, weight:.medium))
                      .frame(maxWidth:.infinity)
                      .padding(8)
                      .background(Color.red)
                      .foregroundColor(.white)
                      .cornerRadius(6)
                }
              .buttonStyle(ClearButtonStyle())
            }
           .padding()
           .frame(width: 220, height: 400)
           .background(Color(NSColor.controlBackgroundColor))

            // 右边内容展示区
            GeometryReader { geometry in
                VStack {
                    if isLoading {
                        Text("正在加载数据...")
                          .font(.system(size: 18, weight:.medium))
                          .padding()
                    } else {
                        let filteredData = searchText.isEmpty ? backendData : backendData.filter { data in
                            data.originalText.lowercased().contains(searchText.lowercased()) ||
                            data.translatedText.lowercased().contains(searchText.lowercased())
                        }

                        List {
                            Text("温馨提示：翻译对比卡片按照艾宾浩斯记忆曲线出现和埋藏")
                                .foregroundColor(Color.red)
                                .font(.system(size: 10))
                                .padding()
                            ForEach(filteredData, id: \.id) { data in
                                VStack(alignment:.leading, spacing: 5) {
                                    HStack {
                                        Text("原文")
                                          .font(.system(size: 16, weight:.medium))
                                          .foregroundColor(Color.gray)
                                        Spacer()
                                        Text(data.originalText)
                                          .font(.system(size: 16, weight:.medium))
                                    }
                                  .padding()
                                  .background(Color(NSColor.windowBackgroundColor))
                                  .cornerRadius(6)
                                  .shadow(radius: 2)
                                  .frame(maxWidth: geometry.size.width)

                                    HStack {
                                        Text("译文")
                                          .font(.system(size: 16, weight:.medium))
                                          .foregroundColor(Color.gray)
                                        Spacer()
                                        Text(data.translatedText)
                                          .font(.system(size: 16, weight:.medium))
                                    }
                                  .padding()
                                  .background(Color(NSColor.windowBackgroundColor))
                                  .cornerRadius(6)
                                  .shadow(radius: 2)
                                  .frame(maxWidth: geometry.size.width)
	

                                    HStack {
                                        Text("源语言")
                                          .font(.system(size: 16, weight:.medium))
                                          .foregroundColor(Color.gray)
                                        Spacer()
                                        Text(data.sourceLanguage)
                                          .font(.system(size: 16, weight:.medium))
                                    }
                                  .padding()
                                  .background(Color(NSColor.windowBackgroundColor))
                                  .cornerRadius(6)
                                  .shadow(radius: 2)
                                  .frame(maxWidth: geometry.size.width)

                                    HStack {
                                        Text("目标语言")
                                          .font(.system(size: 16, weight:.medium))
                                          .foregroundColor(Color.gray)
                                        Spacer()
                                        Text(data.targetLanguage)
                                          .font(.system(size: 16, weight:.medium))
                                    }
                                  .padding()
                                  .background(Color(NSColor.windowBackgroundColor))
                                  .cornerRadius(6)
                                  .shadow(radius: 2)
                                  .frame(maxWidth: geometry.size.width)

                                    HStack {
                                        Text("翻译日期")
                                          .font(.system(size: 16, weight:.medium))
                                          .foregroundColor(Color.gray)
                                        Spacer()
                                        Text(data.translationDate)
                                          .font(.system(size: 16, weight:.medium))
                                    }
                                  .padding()
                                  .background(Color(NSColor.windowBackgroundColor))
                                  .cornerRadius(6)
                                  .shadow(radius: 2)
                                  .frame(maxWidth: geometry.size.width)

                                    HStack {
                                        Text("差异")
                                          .font(.system(size: 16, weight:.medium))
                                          .foregroundColor(Color.gray)
                                        Spacer()
                                        Text(data.differences)
                                          .font(.system(size: 16, weight:.medium))
                                    }
                                  .padding()
                                  .background(Color(NSColor.windowBackgroundColor))
                                  .cornerRadius(6)
                                  .shadow(radius: 2)
                                  .frame(maxWidth: geometry.size.width)
                                }
                            }
                        }
                       .listStyle(PlainListStyle())
                    }
                }
               .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
               .background(Color(NSColor.windowBackgroundColor))
  
            }
        }
       .onAppear {
            // 在视图出现时加载默认数据
           guard let loginId = UserDefaults.standard.string(forKey: "loginId") else {
               print("无法获取用户ID")
               return
           }
           let parameters: [String: Any] = [
               "userId": loginId,
               "page": 1,
               "size": 10
           ]
           fetchTranslationHistory(with:parameters)
        }
    }

    // 修改后的loadData函数，使用Alamofire请求API数据
    func loadData() {
        isLoading = true
        guard let loginId = UserDefaults.standard.string(forKey: "loginId") else {
            print("无法获取用户ID")
            return
        }
        guard !searchText.isEmpty else {
            print("搜索文本不能为空，请输入内容后再进行搜索。")
            isLoading = false
            return
        }

        let parameters: [String: Any] = [
            "userId": loginId,
            "page": 1,
            "size": 10,
            "searchText": searchText
        ]
        fetchTranslationHistory(with: parameters)
    }

    func clearData() {
        backendData = []
    }
    
    func fetchTranslationHistory(with parameters: [String: Any]) {
        let urlString = APIConfigManager.shared.translationHistorySearch
        print("请求URL: \(urlString)")
        print("请求参数: \(parameters)")
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                isLoading = false
                
                switch response.result {
                case .success(let data):
                    print("原始响应数据: \(String(data: data, encoding: .utf8) ?? "无法解码响应数据")")
                    
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode([BackendData].self, from: data)
                        backendData = decodedData
                        print("解析后的数据数量: \(backendData.count)")
                    } catch {
                        print("数据解析错误: \(error)")
                        print("解析失败的JSON: \(String(data: data, encoding: .utf8) ?? "无法显示")")
                    }
                    
                case .failure(let error):
                    print("网络请求失败: \(error)")
                    print("错误详情: \(error.localizedDescription)")
                }
            }
    }
}

struct WrongQuestionBookView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WrongQuestionBookView()
            
        }
    }
}

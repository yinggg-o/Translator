import SwiftUI

struct NewPageView: View {
    @State private var searchText = ""
    @State private var items: [String] = [
        "这是一个段中文",
        "这是一个段英文",
        "这是一个段日文",
        "这是一个段韩文",
        "这是一个段语言文"
    ]
    
    var body: some View {
        VStack {
            // 顶部搜索框
            HStack {
                TextField("搜索短句", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("搜索") {
                    // 搜索逻辑
                }
            }
            .padding()

            // 列表
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        Text("2024/11/23") // 添加时间
                    }
                }
            }

            // 分页按钮
            HStack {
                Button("上一页") {
                    // 上一页逻辑
                }
                .padding()

                Button("下一页") {
                    // 下一页逻辑
                }
                .padding()
            }
        }
        .navigationTitle("短句本")
        .padding()
    }
}

struct NewPageView_Previews: PreviewProvider {
    static var previews: some View {
        NewPageView()
    }
} 
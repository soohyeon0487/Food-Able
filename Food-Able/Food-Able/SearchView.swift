//
//  SearchView.swift
//  Food-Able
//
//  Created by Soohyeon Lee on 2020/12/18.
//

import SwiftUI
import SDWebImageSwiftUI

// 검색 메뉴
struct SearchView: View {
    
    @State var keywordForSeaching: String = ""
    @State var filterViewOffset: CGFloat = UIScreen.main.bounds.size.height
    @State var currentFilterList: [Bool] = [false, false, false]
    
    @State var storeBySearching: [Store] = []
    @State var foodBySearching: [Food] = []
    
    let filterList: [String] = ["exclude Pork", "exclude Beef", "exclude Chicken"]
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        
                        HStack(spacing: 0) {
                            
                            HStack(spacing: 0) {
                                
                                Image(systemName: "magnifyingglass")
                                    .padding(.horizontal, 10)
                                
                                TextField("Input keyword for search", text: self.$keywordForSeaching, onCommit: {
                                    //searchByKeyword()
                                })
                                .padding(.horizontal, 10)
                                
                                if self.keywordForSeaching != "" {
                                    Button(action: {
                                        self.keywordForSeaching = ""
                                    }, label: {
                                        Image(systemName: "multiply.circle.fill")
                                    })
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        self.filterViewOffset = 0
                                    }
                                }, label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .padding(.horizontal)
                                        .padding(.vertical)
                                })
                            }
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.25))
                            .cornerRadius(10)
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        
                        if currentFilterList[0] || currentFilterList[1] || currentFilterList[2] {
                            
                            ScrollView(.horizontal) {
                                
                                HStack(spacing: 10) {
                                    
                                    ForEach(0..<self.currentFilterList.count, id: \.self) { index in
                                        
                                        if self.currentFilterList[index] {
                                            Text("\(self.filterList[index])")
                                                .font(.callout)
                                                .padding(10)
                                                .foregroundColor(.white)
                                                .background(Color("MainColor"))
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 40)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 10)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .background(Color.white.shadow(radius: 5))
                    .background(Color("MainColor").edgesIgnoringSafeArea(.top))
                    
                    ScrollView(.vertical) {
                        
                        Spacer()
                            .frame(height: 10)
                        
                        ForEach(self.storeBySearching) { store in
                            
                            NavigationLink(
                                destination: StoreInfoView(store: store),
                                label: {
                                    VStack(spacing: 0) {
                                        
                                        HStack(spacing: 0) {
                                            
                                            WebImage(url: URL(string:"https://img.insight.co.kr/static/2019/08/12/700/y8jzfe6100x3yvgq39el.jpg"), options: [.progressiveLoad, .delayPlaceholder])
                                                .resizable()
                                                .indicator(.progress)
                                                .frame(width: 120, height: 80, alignment: .center)
                                            
                                            VStack(spacing: 0) {
                                                Text("\(store.name[0])") // 음식점 이름
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    .background(Color.clear)
                                    .padding(.horizontal, 10)
                                })
                            
                            Divider()
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .navigationBarTitle(Text("Search Store and Food"), displayMode: .inline)
                .navigationBarColor(.clear)
            }
            
            FilterView(filterList: self.filterList, currentFilterList: self.$currentFilterList, filterViewOffset: self.$filterViewOffset, newFilterList: self.currentFilterList)
                .offset(y:self.filterViewOffset)
        }
    }
}

struct FilterView : View {
    
    let filterList: [String]
    @Binding var currentFilterList: [Bool]
    @Binding var filterViewOffset: CGFloat
    
    // 현재 뷰에서만 선택된 필터 목록
    @State var newFilterList: [Bool]
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                
                Text("Check filter you want")
                    .padding()
                
                Divider()
                
                ScrollView(.vertical) {
                    
                    VStack(spacing: 0) {
                        
                        VStack(spacing:0) {
                            
                            Text("Category")
                                .bold()
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(0..<self.filterList.count,id: \.self) { index in
                            HStack(spacing: 0) {
                                
                                Toggle(isOn: self.$newFilterList[index]) {
                                    
                                    Text("\(self.filterList[index])")
                                    
                                }.padding()
                            }
                        }
                    }
                }
            }
            .foregroundColor(.black)
            
            Spacer()
            
            HStack() {
                
                // 취소 버튼
                Button(action: {
                    withAnimation {
                        self.newFilterList = self.currentFilterList
                        self.filterViewOffset = UIScreen.main.bounds.size.height
                    }
                }, label: {
                    Text("Cancel")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .background(Color.gray.opacity(0.25))
                        .cornerRadius(10)
                })
                
                // 적용 버튼
                Button(action: {
                    withAnimation {
                        self.filterViewOffset = UIScreen.main.bounds.size.height
                        self.currentFilterList = self.newFilterList
                    }
                }, label: {
                    Text("Apply")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color("MainColor"))
                        .cornerRadius(10)
                    
                })
            }
            .padding(.horizontal, 10)
            .padding(.vertical)
            .buttonStyle(PlainButtonStyle())
            
        }
        .background(Color.white)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

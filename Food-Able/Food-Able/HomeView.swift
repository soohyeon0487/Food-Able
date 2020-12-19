//
//  HomeView.swift
//  Food-Able
//
//  Created by Soohyeon Lee on 2020/12/18.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

struct HomeView : View {
    
    @EnvironmentObject var univList: UnivList
    @EnvironmentObject var storeList: StoreList
    
    @Binding var univPickerOffset: CGFloat
    @Binding var currentRegion: MKCoordinateRegion
    
    // 음식점 분류
    let foodCategoryList: [String] = ["전체", "한식", "중식", "일식", "카페", "간식"]
    
    // 음식점 목록
    @State var selectedStoreID = 0
    @State var activeStoreID: Int?
    
    // 임시 음식점 사진
    let urlList: [String] = ["https://www.mycity24.com.au/mycityko/pad_img/38635_1.jpg",
                             "https://i.ytimg.com/vi/FfuH36TNWjE/maxresdefault.jpg",
                             "https://i.ytimg.com/vi/QPDI36BL_2Q/maxresdefault.jpg",
                             "https://img.insight.co.kr/static/2019/08/12/700/y8jzfe6100x3yvgq39el.jpg",
                             "https://kofice.or.kr/dext5editordata/2016/11/20161113_08482901_38766.png"]
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                
                // 대학 이름
                HStack(spacing: 0) {
                    
                    Button(action: {
                        withAnimation {
                            self.univPickerOffset = 0
                        }
                    }, label: {
                        VStack(spacing: 0) {
                            Text("\(self.univList.list[self.univList.selectedUnivIndex].name[0])")
                                .font(.title)
                        }
                        .frame(height: 45)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color("MainColor").edgesIgnoringSafeArea(.top))
                    })
                }
                .buttonStyle(PlainButtonStyle())
                
                // 음식점 분류 -- TODO : 카테고리 값에 따른 노출
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 0) {
                        
                        ForEach(0..<self.foodCategoryList.count, id: \.self){ index in
                            
                            Button(action: {
                                
                                if self.storeList.selectedFoodCategoryIndex != index {
                                    self.storeList.selectedFoodCategoryIndex = index
                                    self.storeList.filteringStoreList(univ: self.univList.selectedUnivIndex)
                                }
                            }) {
                                VStack(alignment: .center, spacing: 0) {
                                    Text("\(self.foodCategoryList[index])")
                                        .font(.system(size: 16))
                                        .foregroundColor(self.storeList.selectedFoodCategoryIndex == index ? .black : .gray)
                                        .frame(height: 40)
                                    
                                    // 강조 밑줄
                                    CustomShape()
                                        .fill(self.storeList.selectedFoodCategoryIndex == index ? Color("MainColor") : Color.white)
                                        .frame(width: 50, height: 2)
                                }
                            }
                            .padding(.horizontal, 10)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal, 10)
                }
            }
            .background(Color.white.shadow(radius: 5))
            
            ScrollView(.vertical) {
                
                Spacer()
                    .frame(height: 10)
                
                ForEach(self.storeList.currentList) { store in
                    
                    NavigationLink(
                        destination: StoreInfoView(store: store),
                        tag: store.id,
                        selection: $activeStoreID,
                        label: {
                            VStack(spacing: 0) {
                                
                                HStack(spacing: 0) {
                                    
                                    WebImage(url: URL(string:self.urlList[store.id]), options: [.progressiveLoad, .delayPlaceholder])
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
                            .background(Color.white)
                            .padding(.horizontal, 10)
                        })
                    
                    Divider()
                }.buttonStyle(PlainButtonStyle())
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            
            Spacer().frame(height: 50)
        }
        .onOpenURL(perform: { url in
            
            guard let viewID = url.viewIdentifier else { return }
            
            let pageID = url.pageIdentifier
            
            if viewID == .store {
                
                if 0 <= pageID && pageID < self.storeList.list.count {
                    
                    self.activeStoreID = pageID
                    
                }
            }
            
            return
        })
    }
}

struct StoreInfoView : View {
    
    // 음식점 정보
    let store: Store
    
    // 음식 목록
    let foodList = ["Pork Soup and Rice", "Traditional Korean Sausage in Pork broth soup", "Pork intentines in a Pork broth soup", "Sliced Pork"]
    
    // 임시 음식 이미지
    let foodImageList = ["https://img.insight.co.kr/static/2019/08/12/700/y8jzfe6100x3yvgq39el.jpg",
                         "https://i.pinimg.com/736x/3f/5a/d1/3f5ad1178433558451bd36526af23d96.jpg",
                         "https://cdn.ppomppu.co.kr/zboard/data3/2019/0928/m_20190928081059_rcymdlnw.jpg",
                         "https://craftlog.com/m/i/6053542=s1280=h960"]
    
    // 임시 음식 가격
    let priceList = ["8,000", "8,000", "8,000", "9,000"]
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                
                // 상단 이미지
                VStack(spacing: 0) {
                    WebImage(url: URL(string:"https://img.insight.co.kr/static/2019/08/12/700/y8jzfe6100x3yvgq39el.jpg"), options: [.progressiveLoad, .delayPlaceholder])
                        .resizable()
                        .indicator(.progress)
                        .frame(height: 200)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .background(Color.green)
                    
                    Spacer()
                }
                
                // 음식점 정보
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        
                        VStack(spacing: 0) {
                            
                            Text("\(self.store.name[0])")
                                .font(.title)
                            Text("Warm soup and delicious kimchi")
                                .font(.subheadline)
                        }
                        .padding()
                        
                        Divider()
                        
                        HStack(spacing: 0) {
                            
                            Button(action: {
                                
                            }, label: {
                                HStack(spacing: 0) {
                                    Image(systemName: "heart")
                                        .padding(10)
                                    Text("Like \(self.store.likes)")
                                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(Color.white)
                            })
                            
                            Divider()
                            
                            Button(action: {
                                
                            }, label: {
                                HStack(spacing: 0) {
                                    Image(systemName: "square.and.arrow.up")
                                        .padding(10)
                                    Text("Share")
                                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(Color.white)
                            })
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(height: 120)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                }
            }
            .frame(height: 250)
            .padding(.bottom, 10)
            
            ScrollView(.vertical) {
                
                ForEach(0..<self.foodList.count,id: \.self){ index in
                    
                    NavigationLink(
                        destination: MenuInfoView(index: index),
                        label: {
                            VStack(spacing: 0) {
                                
                                HStack(spacing: 0) {
                                    
                                    WebImage(url: URL(string:self.foodImageList[index]), options: [.progressiveLoad, .delayPlaceholder])
                                        .resizable()
                                        .indicator(.progress)
                                        .frame(width: 120, height: 80, alignment: .center)
                                    
                                    VStack(spacing: 0) {
                                        Text("\(self.foodList[index])") // 음식 이름
                                            .padding(.horizontal, 10)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    
                                    VStack(spacing: 0) {
                                        Text("\(self.priceList[index])")
                                        Text("Won")
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .padding(.horizontal, 10)
                        })
                    
                    Divider()
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .navigationBarColor(.clear)
    }
}

struct MenuInfoView : View {
    
    let index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            ZStack {
                
                VStack(spacing: 0) {
                    WebImage(url: URL(string:"https://img.insight.co.kr/static/2019/08/12/700/y8jzfe6100x3yvgq39el.jpg"), options: [.progressiveLoad, .delayPlaceholder])
                        .resizable()
                        .indicator(.progress)
                        .frame(height: 200)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .background(Color.green)
                    
                    Spacer()
                }
                
                // 음식점 정보
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        
                        VStack(spacing: 0) {
                            Text("Pork Soup and Rice")
                                .font(.title)
                            //                            Text("맛난 거 많이 들어감! 아무튼 재료 많음")
                            //                                .font(.subheadline)
                        }
                        .padding()
                        
                        Divider()
                        
                        HStack(spacing: 0) {
                            
                            Button(action: {
                                
                            }, label: {
                                HStack(spacing: 0) {
                                    Image(systemName: "heart")
                                        .padding(10)
                                    Text("Like")
                                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(Color.white)
                            })
                            
                            Divider()
                            
                            Button(action: {
                                
                            }, label: {
                                HStack(spacing: 0) {
                                    Image(systemName: "square.and.arrow.up")
                                        .padding(10)
                                    Text("Share")
                                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(Color.white)
                            })
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(height: 100)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                }
            }
            .frame(height: 250)
            .padding(.bottom, 10)
            
            VStack(spacing: 0) {
                Text("Price")
                    .font(.headline)
                    .padding()
                
                HStack(spacing: 0) {
                    
                    HStack(spacing: 0) {
                        WebImage(url: URL(string:"https://cdn.crowdpic.net/list-thumb/thumb_l_923F46208A61FB9CCA6B700109BD1AEA.jpg"), options: [.progressiveLoad, .delayPlaceholder])
                            .resizable()
                            .indicator(.progress)
                            .frame(width: 50, height: 25)
                        
                        Text(" x 8")
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
                    HStack(spacing: 0) {
                        Text("8,000 Won")
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
            .padding(.horizontal, 10)
            
            VStack(spacing: 0) {
                Text("Food Description")
                    .font(.headline)
                    .padding()
                
                Text("In the soup made of pork bones and meat, cut the boiled meat and put rice in it.")
                    .font(.subheadline)
                    .padding()
            }
            .padding(.horizontal, 10)
            
            VStack(spacing: 0) {
                Text("Ingredient to be checked")
                    .font(.headline)
                    .padding()
                
                VStack(spacing: 10) {
                    Text("allergy-related [X]")
                        .font(.subheadline)
                    Text("Pork [O]")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .navigationBarColor(.clear)
    }
}

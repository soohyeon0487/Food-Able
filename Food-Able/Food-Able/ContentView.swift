//
//  ContentView.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/05.
//

import SwiftUI
import MapKit
import CodeScanner


/// 최상위 뷰
struct ContentView: View {
    
    // URL Scheme
    @Environment(\.openURL) var openURL
    
    // EnvironmentObject
    @EnvironmentObject var univList: UnivList
    @EnvironmentObject var storeList: StoreList
    
    // UnivPickerView
    @State var univPickerOffset: CGFloat = UIScreen.main.bounds.size.height
    
    // 현재 화면 메뉴 번호
    @State var selectedMenuIndex: Int = 1
    
    // MapView
    @State var currentRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    // QR Scanner
    @State var isShowingScanner: Bool = false
    @State var dataFromQRCode: String = ""
    
    var body: some View {
        NavigationView {
            
            if !self.univList.isComplete {
                Spacer()
            } else {
                
                ZStack {
                    
                    Text("\(self.selectedMenuIndex)")
                        .opacity(self.selectedMenuIndex == 0 ? 1 : 0)
                    
                    MapView(univPickerOffset: self.$univPickerOffset, currentRegion: self.$currentRegion)
                        .opacity(self.selectedMenuIndex == 1 ? 1 : 0)
                    
                    HomeView(univPickerOffset: self.$univPickerOffset, currentRegion: self.$currentRegion)
                        .foregroundColor(.black)
                        .opacity(self.selectedMenuIndex == 2 ? 1 : 0)
                    
                    Text("\(self.selectedMenuIndex)")
                        .opacity(self.selectedMenuIndex == 3 ? 1 : 0)
                    
                    // Bottom Bar
                    VStack(spacing: 0) {
                        
                        Spacer()
                        
                        ZStack(alignment: .bottom){
                            
                            HStack(spacing: 0) {
                                
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 33.5 + CGFloat(self.selectedMenuIndex) * 70)
                                
                                Circle()
                                    .foregroundColor(Color.red.opacity(0.2))
                                    .frame(width: 30, height: 30)
                                
                            }
                            .padding(.vertical)
                            //.padding(.horizontal, 18)
                            .frame(height: 50)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.shadow(radius: 5))
                            
                            // 하단 메뉴바
                            BottomBar(selectedMenuIndex: self.$selectedMenuIndex)
                                .padding()
                                .padding(.horizontal, 22)
                                .frame(height: 50)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            
                            // QR Camera
                            HStack {
                                
                                Spacer()
                                
                                Button(action: {
                                    self.isShowingScanner = true
                                }, label: {
                                    Image(systemName: "qrcode")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding(10)
                                })
                                .background(Color("MainColor"))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .padding()
                                .padding(.bottom, 50)
                                .sheet(isPresented: self.$isShowingScanner) {
                                    CodeScannerView(codeTypes: [.qr], simulatedData: "foodable://store", completion: self.handleScan)
                                }
                            }
                        }
                    }
                    
                    UnivPickerView(univPickerOffset: self.$univPickerOffset, currentRegion: self.$currentRegion)
                        .offset(y:self.univPickerOffset)
                }
                .foregroundColor(.black)
                .background(Color.white)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
            }
        }
        .onOpenURL(perform: { url in
            
            guard let viewID = url.viewIdentifier else { return }
            
            self.selectedMenuIndex = viewID.rawValue
        })
    }
    
    // QR 코드 관련 이벤트 처리
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            print("Scanning success")
            print("\(code)")
            self.dataFromQRCode = code
            
            openURL(URL(string: self.dataFromQRCode)!)
            
        case .failure(let error):
            print("Scanning failure")
            print("\(error)")
        }
    }
}

struct BottomBar : View {
    
    @Binding var selectedMenuIndex : Int
    
    var body : some View{
        
        HStack(spacing: 0){
            
            // 추천
            Button(action: {
                withAnimation {
                    self.selectedMenuIndex = 0
                }
            }) {
                Image(systemName: "hand.thumbsup")
            }.foregroundColor(self.selectedMenuIndex == 0 ? .black : .gray)
            
            Spacer()
            
            // 지도
            Button(action: {
                withAnimation {
                    self.selectedMenuIndex = 1
                }
            }) {
                Image(systemName: "map")
            }.foregroundColor(self.selectedMenuIndex == 1 ? .black : .gray)
            
            Spacer()
            
            // 홈
            Button(action: {
                withAnimation {
                    self.selectedMenuIndex = 2
                }
            }) {
                Image(systemName: "house")
            }.foregroundColor(self.selectedMenuIndex == 2 ? .black : .gray)
            
            Spacer()
            
            // 즐겨찾기
            Button(action: {
                withAnimation {
                    self.selectedMenuIndex = 3
                }
            }) {
                Image(systemName: "heart")
            }.foregroundColor(self.selectedMenuIndex == 3 ? .black : .gray)
            
            Spacer()
            
            // 검색
            NavigationLink(
                destination: SearchView(),
                label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                })
        }
        
    }
}

struct UnivPickerView : View {
    
    @EnvironmentObject var univList: UnivList
    @EnvironmentObject var storeList: StoreList
    
    @Binding var univPickerOffset: CGFloat
    @Binding var currentRegion: MKCoordinateRegion
    
    @State var selectingUnivIndex: Int = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.black.opacity(0.0001))
                .onTapGesture(perform: {
                    withAnimation {
                        self.univPickerOffset = UIScreen.main.bounds.size.height
                    }
                })
            
            VStack(spacing: 0) {
                
                Text("대학교를 고르세요")
                    .padding()
                
                Divider()
                
                Picker(selection: self.$selectingUnivIndex, label: Text("\(self.univList.list[self.univList.selectedUnivIndex].name[0])")) {
                    
                    ForEach(self.univList.list) { univ in
                        Text("\(univ.name[0])")
                    }
                }
                .foregroundColor(.black)
                
                HStack() {
                    
                    Button(action: {
                        withAnimation {
                            self.univPickerOffset = UIScreen.main.bounds.size.height
                        }
                    }, label: {
                        Text("취소")
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .background(Color.gray.opacity(0.25))
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        self.univList.selectedUnivIndex = self.selectingUnivIndex
                        
                        self.storeList.selectedFoodCategoryIndex = 0
                        self.storeList.filteringStoreList(univ: self.univList.selectedUnivIndex)
                        
                        withAnimation {
                            self.univPickerOffset = UIScreen.main.bounds.size.height
                            self.currentRegion = self.univList.list[self.univList.selectedUnivIndex].region
                        }
                    }, label: {
                        Text("선택")
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color("MainColor"))
                            .cornerRadius(10)
                    })
                }
                .padding(.horizontal, 10)
                .padding(.vertical)
            }
            .background(Color.white.shadow(radius: 5))
        }
    }
}


/// Main Menu

// 추천 메뉴
//



// 즐겨찾기 메뉴
//


///

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UnivList())
            .environmentObject(StoreList())
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}


enum ViewIdentifier: Int {
    case recommand
    case map
    case store
    case favorites
}

extension URL {
    
    // URL 양식
    // foodable://store/1
    // [scheme]://[host]/etc
    
    // foodable://store -> pathComponents.count = 0
    // foodable://store/ -> pathComponents.count = 1
    // foodable://store/111 -> pathComponents.count = 2
    // foodable://store/111/ -> pathComponents.count = 3
    
    // foodable://store[/][111][/] -> pathComponents.count = 3
    
    // 딥링크 적합 여부
    var isDeepLink: Bool {
        
        return scheme == "foodable"
    }
    
    // url과 View 연동
    var viewIdentifier: ViewIdentifier? {
        guard isDeepLink else { return nil }
        
        
        switch host {
        
        case "recommand":
            return .recommand
            
        case "map":
            return .map
            
        case "store":
            return .store
            
        case "favorites":
            return .favorites
            
        default:
            return nil
        }
    }
    
    var pageIdentifier: Int  {
        
        guard let viewID = viewIdentifier else { return -1 }
        
        // 상세 주소가 있으면
        if pathComponents.count > 1 {
            
            let id = pathComponents[1]
            
            return Int(id)!
        }
        
        return -1
    }
}

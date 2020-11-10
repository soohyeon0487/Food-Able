//
//  ContentView.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/05.
//

import SwiftUI
import CodeScanner
import SDWebImageSwiftUI

/// 최상위 뷰
struct ContentView: View {
	
	// 현재 화면 메뉴 번호
	@State var selectedMenuIndex: Int = 2
	
	// 학교 선택
	let univList = ["Konkuk Univ.", "Chung-Ang Univ.", "Kyung Hee Univ."]
	@State var selectedUnivIndex = 0
	@State var univPickerOffset: CGFloat = UIScreen.main.bounds.size.height
	
	// QR 코드 관련 변수
	@State var isShowingScanner: Bool = false
	@State var isShowingWebView: Bool = false
	@State var dataFromQRCode: String = ""
	
	var body: some View {
		NavigationView {
			ZStack {
				
				Text("\(self.selectedMenuIndex)")
					.opacity(self.selectedMenuIndex == 0 ? 1 : 0)
				
				Text("\(self.selectedMenuIndex)")
					.opacity(self.selectedMenuIndex == 1 ? 1 : 0)
				
				HomeView(univNameList: self.univList, selectedUnivIndex: self.$selectedUnivIndex, univPickerOffset: self.$univPickerOffset)
					.foregroundColor(.black)
					.opacity(self.selectedMenuIndex == 2 ? 1 : 0)
				
				Text("\(self.selectedMenuIndex)")
					.opacity(self.selectedMenuIndex == 3 ? 1 : 0)
				
				// Bottom Bar
				VStack(spacing: 0) {
					
					Spacer()
					
					ZStack(alignment: .bottom){
						
						// 하단 메뉴바
						BottomBar(selectedMenuIndex: self.$selectedMenuIndex)
							.padding()
							.padding(.horizontal, 22)
							.frame(height: 50)
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
							.background(Color.white.shadow(radius: 5))
						
						// QR Camera
						HStack {
							
							Spacer()
							
							NavigationLink(
								destination:
									// 현재는 웹뷰 -> 차후 앱 내 링크로 연결
									MyWebview(urlToLoad: self.dataFromQRCode)
									.edgesIgnoringSafeArea(.all)
									.navigationBarTitle(self.dataFromQRCode, displayMode: .inline)
								,
								isActive: self.$isShowingWebView,
								label: {
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
									.sheet(isPresented: self.$isShowingScanner) {
										CodeScannerView(codeTypes: [.qr], simulatedData: "https://www.naver.com", completion: self.handleScan)
									}
								})
									.padding()
									.padding(.bottom, 50)
						}
						
					}
				}
				
				// 대학 고르기
				UnivPickerView(univList: self.univList, selectedUnivIndex: self.$selectedUnivIndex, univPickerOffset: self.$univPickerOffset)
					.offset(y:self.univPickerOffset)
			}
			.foregroundColor(.black)
			.background(Color.white)
			.navigationBarTitle("", displayMode: .inline)
			.navigationBarHidden(true)
		}
	}
	
	// QR 코드 관련 이벤트 처리
	func handleScan(result: Result<String, CodeScannerView.ScanError>) {
		self.isShowingScanner = false
		
		switch result {
		case .success(let code):
			print("Scanning success")
			print("\(code)")
			self.dataFromQRCode = code
			self.isShowingWebView = true
			
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
				self.selectedMenuIndex = 0
			}) {
				Image(systemName: "hand.thumbsup")
			}.foregroundColor(self.selectedMenuIndex == 0 ? .black : .gray)
			
			Spacer()
			
			// 지도
			Button(action: {
				self.selectedMenuIndex = 1
			}) {
				Image(systemName: "map")
			}.foregroundColor(self.selectedMenuIndex == 1 ? .black : .gray)
			
			Spacer()
			
			// 홈
			Button(action: {
				self.selectedMenuIndex = 2
			}) {
				Image(systemName: "house")
			}.foregroundColor(self.selectedMenuIndex == 2 ? .black : .gray)
			
			Spacer()
			
			// 즐겨찾기
			Button(action: {
				self.selectedMenuIndex = 3
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
	
	let univList: [String]
	@Binding var selectedUnivIndex: Int
	@Binding var univPickerOffset: CGFloat
	@State var selectingUnivIndex: Int = 0
	
	var body: some View {
		
		VStack(spacing: 0) {
			
			//Spacer()
			Rectangle()
				.foregroundColor(.clear)
				.background(Color.black.opacity(0.0001))
				.onTapGesture(perform: {
					withAnimation {
						self.univPickerOffset = UIScreen.main.bounds.size.height
					}
				})
			
			VStack(spacing: 0) {
				
				Text("Choose A University")
					.padding()
				
				Divider()
				
				
				Picker(selection: self.$selectingUnivIndex, label: Text("\(self.univList[self.selectingUnivIndex])")) {
					ForEach(0 ..< univList.count) {
						Text(self.univList[$0])
					}
				}
				
				HStack() {
					
					Button(action: {
						withAnimation {
							self.univPickerOffset = UIScreen.main.bounds.size.height
						}
					}, label: {
						Text("Cancel")
							.padding()
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
							.background(Color.gray.opacity(0.25))
							.cornerRadius(10)
					})
					
					Button(action: {
						withAnimation {
							self.selectedUnivIndex = self.selectingUnivIndex
							self.univPickerOffset = UIScreen.main.bounds.size.height
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
				
			}
			.foregroundColor(.black)
			.background(Color.white.shadow(radius: 5))
		}
	}
}
///

/// Main Menu

// 추천 메뉴
//

// 지도 기반 메뉴
//

// 메인 메뉴
struct HomeView : View {

	let univNameList: [String]
	@Binding var selectedUnivIndex: Int
	@Binding var univPickerOffset: CGFloat
	
	// 음식 종류 선택
	let foodCategoryList: [String] = ["All", "Korean", "Chinese", "Japanese", "Cafe", "Snack"]
	@State var selectedFoodCategoryIndex: Int = 0
	
	// 음식점 목록
	let storeList: [String] = ["Chinese Restaurant", "Gimbap Heaven", "Galbi Naengmyeon", "Handmade Dumplings", "Rice Soup", "Cup Rice"]
	let urlList: [String] = ["https://www.mycity24.com.au/mycityko/pad_img/38635_1.jpg",
							 "https://lh3.googleusercontent.com/proxy/kZgduVk23F6sHGeqE0VdQQfT14U70lC2EAuLRYFIx8POIqw_jqp63K3nfpWaUIrIi8CjRklqfMOY1EiNeXh2UXXpwXc7XLYvYjurO2WFZqs",
							 "https://i.ytimg.com/vi/FfuH36TNWjE/maxresdefault.jpg",
							 "https://i.ytimg.com/vi/QPDI36BL_2Q/maxresdefault.jpg",
							 "https://img.insight.co.kr/static/2019/08/12/700/y8jzfe6100x3yvgq39el.jpg",
							 "https://kofice.or.kr/dext5editordata/2016/11/20161113_08482901_38766.png"]
	
	@State var selectedStoreID = 0

	var body: some View {

		VStack(spacing: 0) {
			
			VStack(spacing: 0) {
				
				HStack(spacing: 0) {
					
					Button(action: {
						withAnimation {
							self.univPickerOffset = 0
						}
					}, label: {
						Text("\(self.univNameList[self.selectedUnivIndex])")
					})
				}
				.frame(height: 45)
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
				.font(.title)
				.foregroundColor(.white)
				.background(Color("MainColor").edgesIgnoringSafeArea(.top))
				.buttonStyle(PlainButtonStyle())
				// TODO : 학교별 컬러와 글자색 변경?
				
				// Food Category
				ScrollView(.horizontal, showsIndicators: false) {
					
					HStack(spacing: 0) {
						
						ForEach(0..<self.foodCategoryList.count, id: \.self){ index in
							
							Button(action: {
								self.selectedFoodCategoryIndex = index
							}) {
								VStack(alignment: .center, spacing: 0) {
									Text("\(self.foodCategoryList[index])")
										.font(.system(size: 16))
										.foregroundColor(self.selectedFoodCategoryIndex == index ? .black : .gray)
										.frame(height: 40)
									
									// 강조 밑줄
									CustomShape()
										.fill(self.selectedFoodCategoryIndex == index ? Color("MainColor") : Color.clear)
										.frame(width: 50, height: 2)
								}
							}
							.padding(.horizontal, 10)
							
						}
						.buttonStyle(PlainButtonStyle())
					}
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding(.horizontal, 10)
				}
			}
			.background(Color.white.shadow(radius: 5))
			
			ScrollView(.vertical) {
				
				Spacer()
					.frame(height: 10)
				
				ForEach(0..<self.storeList.count,id: \.self){ index in
					
					NavigationLink(
						destination: StoreInfoView(index: index, name: self.storeList[index]),
						label: {
							
							VStack(spacing: 0) {
								
								HStack(spacing: 0) {
									
									WebImage(url: URL(string:self.urlList[index]), options: [.progressiveLoad, .delayPlaceholder])
										.resizable()
										.indicator(.progress)
										.frame(width: 120, height: 80, alignment: .center)
									
									VStack(spacing: 0) {
										Text("\(self.storeList[index])") // 음식점 이름
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
				}
				.buttonStyle(PlainButtonStyle())
			}
			.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
			
			Spacer().frame(height: 50)
		}
	}
}

struct StoreInfoView : View {
	
	let index: Int
	
	let name: String
	
	let foodList = ["Pork Soup and Rice", "Traditional Korean Sausage in Pork broth soup", "Pork intentines in a Pork broth soup", "Sliced Pork"]
	
	let foodImageList = ["https://img.insight.co.kr/static/2019/08/12/700/y8jzfe6100x3yvgq39el.jpg",
						 "https://i.pinimg.com/736x/3f/5a/d1/3f5ad1178433558451bd36526af23d96.jpg",
						 "https://cdn.ppomppu.co.kr/zboard/data3/2019/0928/m_20190928081059_rcymdlnw.jpg",
						 "https://craftlog.com/m/i/6053542=s1280=h960"]
	
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
							
							Text("Rice Soup")
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
							//							Text("맛난 거 많이 들어감! 아무튼 재료 많음")
							//								.font(.subheadline)
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
//

// 즐겨찾기 메뉴
//

// 검색 메뉴
struct SearchView: View {
	
	@State var keywordForSeaching: String = ""
	@State var filterViewOffset: CGFloat = UIScreen.main.bounds.size.height
	@State var currentFilterList: [Bool] = [false, false, false]
	
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
									print("\(self.keywordForSeaching)")
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
					
					Spacer()
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
//

///

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		//ContentView()
		StoreInfoView(index: 0, name: "중국집")
			.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
	}
}

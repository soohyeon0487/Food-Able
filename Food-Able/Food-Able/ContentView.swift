//
//  ContentView.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
	
	var body: some View {
		NavigationView {
			HomeView()
				.navigationBarTitle("", displayMode: .inline)
				.navigationBarHidden(true)
		}
	}
}

struct HomeView : View {
	
	@State var selected = 0
	
	// 학교 선택
	@State var pickerOffset = UIScreen.main.bounds.size.height
	let names = ["SKT", "KT", "LGT", "GT", "ET", "TT"]
	@State var selectedNameIndex = 0
	
	// 음식 종류 선택
	let categories: [String] = ["Korean", "Chinese", "Japanese", "Cafe", "Snack"]
	@State var selectedCategoryIndex: Int = 0
	
	// 음식점 목록
	let restaurants: [String] = ["0번 음식점", "1번 음식점", "2번 음식점", "3번 음식점", "4번 음식점", "5번 음식점"]
	let urlList: [String] = ["http://placekitten.com/1500/1000",
							 "http://placekitten.com/1501/1000",
							 "http://placekitten.com/1500/1001",
							 "http://placekitten.com/1499/1000",
							 "http://placekitten.com/1500/999",
							 "http://placekitten.com/1501/999"]
	@State var selectedRestaurantID = 0
	
	var body: some View {
		
		ZStack {
			
			// TopBar()
			// Contents
			VStack(spacing: 0) {
				
				HStack(spacing: 0) {
					
					Button(action: {
						withAnimation {
							self.pickerOffset = 0
						}
					}, label: {
						Text("\(self.names[self.selectedNameIndex])")
					})
					
				}
				.frame(height: 45)
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
				.font(.title)
				.foregroundColor(.white)
				.background(Color("MainColor").edgesIgnoringSafeArea(.top))
				.buttonStyle(PlainButtonStyle())
				// TODO : 학교별 컬러와 글자색 변경?
				
				// Food Style
				ScrollView(.horizontal, showsIndicators: false) {
					
					HStack(spacing: 0) {
						
						ForEach(0..<self.categories.count, id: \.self){ index in
							
							Button(action: {
								self.selectedCategoryIndex = index
							}) {
								VStack(alignment: .center, spacing: 0) {
									Text("\(self.categories[index])")
										.font(.system(size: 16))
										.foregroundColor(self.selectedCategoryIndex == index ? .black : .gray)
										.frame(height: 40)
									
									CustomShape()
										.fill(self.selectedCategoryIndex == index ? Color("MainColor") : Color.clear)
										.frame(width: 50, height: 2)
								}
							}
							.padding(.horizontal, 10)
							
						}
						.buttonStyle(PlainButtonStyle())
					}
					.frame(minWidth: 0, maxWidth: .infinity)
				}
				.padding(.horizontal, 10)
				
				Divider()
					.padding(.bottom, 20)
				
				ScrollView(.vertical) {
					
					ForEach(0..<self.restaurants.count,id: \.self){ index in
						
						NavigationLink(
							destination: RestaurantInfoView(index: index, name: self.restaurants[index]),
							label: {
								VStack(spacing: 0) {
									HStack(spacing: 0) {
										
										WebImage(url: URL(string:self.urlList[index]), options: [.progressiveLoad, .delayPlaceholder])
											.resizable()
											.indicator(.progress)
											.frame(width: 120, height: 80, alignment: .center)
										
										VStack(spacing: 0) {
											Text("\(self.restaurants[index])") // 음식점 이름
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
					}
					.buttonStyle(PlainButtonStyle())
					
					
				}
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
				
				Spacer().frame(height: 50)
			}
			.foregroundColor(.black)
			
			
			
			// Bottom Bar
			VStack(spacing: 0) {
				
				Spacer()
				
				Divider()
				
				ZStack(alignment: .top){
					
					BottomBar(selected: self.$selected)
						.padding()
						.padding(.horizontal, 22)
						.frame(height: 50)
						.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
						.background(Color.white)
					
					// QR Camera
					Button(action: {
						
					}) {
						
						Image(systemName: "qrcode")
							.foregroundColor(.white)
							.padding()
						
					}
					.background(Color("MainColor"))
					.clipShape(Circle())
					.offset(y: -15)
					.shadow(radius: 5)
				}
				
				
			}
			
			// Picker
			NamePickerView(names: self.names, selectedNameIndex: self.$selectedNameIndex, pickerOffset: self.$pickerOffset)
			.offset(y:self.pickerOffset)
		}
		.foregroundColor(.black)
		.background(Color.white)
	}
}

struct BottomBar : View {
	
	@Binding var selected : Int
	
	var body : some View{
		
		HStack{
			
			Button(action: {
				
				self.selected = 0
				
			}) {
				
				Image(systemName: "hand.thumbsup")
				
			}.foregroundColor(self.selected == 0 ? .black : .gray)
			
			Spacer(minLength: 12)
			
			
			Button(action: {
				
				self.selected = 1
				
			}) {
				
				Image(systemName: "map")
				
			}.foregroundColor(self.selected == 1 ? .black : .gray)
			
			
			Spacer().frame(width: 120)
			
			Button(action: {
				
				self.selected = 2
				
			}) {
				
				Image(systemName: "heart")
				
			}.foregroundColor(self.selected == 2 ? .black : .gray)
			
			
			Spacer(minLength: 12)
			
			Button(action: {
				
				self.selected = 3
				
			}) {
				
				Image(systemName: "magnifyingglass")
				
			}.foregroundColor(self.selected == 3 ? .black : .gray)
		}
	}
}

struct NamePickerView : View {
	
	let names: [String]
	@Binding var selectedNameIndex: Int
	@Binding var pickerOffset: CGFloat
	@State var selectingNameIndex: Int = 0
	
	var body: some View {
		VStack(spacing: 0) {
			
			//Spacer()
			Rectangle()
				.foregroundColor(.clear)
				.background(Color.black.opacity(0.0001))
				.onTapGesture(perform: {
					withAnimation {
						self.pickerOffset = UIScreen.main.bounds.size.height
					}
				})
			
			VStack(spacing: 0) {
				HStack(spacing: 0) {
					
					Spacer()
					
					Button(action: {
						withAnimation {
							self.pickerOffset = UIScreen.main.bounds.size.height
							self.selectedNameIndex = self.selectingNameIndex
						}
					}, label: {
						Text("Confirm")
					})
					.padding()
				}
				
				Picker(selection: self.$selectingNameIndex, label: Text("\(self.names[self.selectedNameIndex])")) {
					ForEach(0 ..< names.count) {
						Text(self.names[$0])
					}
				}
			}
			.foregroundColor(.black)
			.background(Color.white.shadow(radius: 5))
		}
	}
}

struct RestaurantInfoView : View {
	
	let index: Int
	
	let name: String
	
	let foodList = ["짜장면 가즈아", "짬뽕은 어때", "탕수육은 필수", "울면 안대", "비싼거 시키자 팔보채"]
	
	var body: some View {
		VStack(spacing: 0) {
			
			// Header
			ZStack {
				
				VStack(spacing: 0) {
					WebImage(url: URL(string:"http://placekitten.com/750/500"), options: [.progressiveLoad, .delayPlaceholder])
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
							Text("음식점 이름 \(self.index)")
								.font(.title)
							Text("고양이 귀엽... \(self.index)")
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
									
									WebImage(url: URL(string:"http://placekitten.com/500/350"), options: [.progressiveLoad, .delayPlaceholder])
										.resizable()
										.indicator(.progress)
										.frame(width: 120, height: 80, alignment: .center)
									
									VStack(spacing: 0) {
										Text("\(self.foodList[index])") // 음식 이름
									}
									.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
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
					WebImage(url: URL(string:"http://placekitten.com/900/600"), options: [.progressiveLoad, .delayPlaceholder])
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
							Text("음식 이름 \(self.index)")
								.font(.title)
							Text("맛난 거 많이 들어감! 아무튼 재료 많음")
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
			
			VStack(spacing: 0) {
				Text("가격")
					.font(.headline)
					.padding()
				
				HStack(spacing: 0) {
					
					HStack(spacing: 0) {
						Image(systemName: "dollarsign.circle")
						Image(systemName: "dollarsign.circle")
						Image(systemName: "dollarsign.circle")
						Image(systemName: "dollarsign.circle")
					}.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
					
					HStack(spacing: 0) {
						Text("7000원")
					}.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
				}
				.padding()
			}
			.padding(.horizontal, 10)
		
			VStack(spacing: 0) {
				Text("음식 설명")
					.font(.headline)
					.padding()
				
				Text("이래저래 이래저래 뭔가 들어가서 맛있을껄? \n음식점 사장님이 아무말이나 좀 적어줬으면")
					.font(.subheadline)
					.padding()
			}
			.padding(.horizontal, 10)
			
			VStack(spacing: 0) {
				Text("재료")
					.font(.headline)
					.padding()
				
				Text("대표적인 알러지 종류 해당하는 거랑 돼지고기 포함 여부 정도만 일단 적어놓으면 되겠지....")
					.font(.subheadline)
					.padding()
			}
			.padding(.horizontal, 10)
			
			Spacer()
			
		}
		.background(Color.white)
		.edgesIgnoringSafeArea(.top)
		.navigationBarColor(.clear)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		//ContentView()
		MenuInfoView(index: 0)
	}
}

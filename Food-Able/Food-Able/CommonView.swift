//
//  CommonView.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/05.
//

import SwiftUI
import Combine
import Foundation

struct CustomShape: Shape {
	
	func path(in rect: CGRect) -> Path {
		
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
		
		return Path(path.cgPath)
	}
}

struct NavigationBarModifier: ViewModifier {
		
	var backgroundColor: UIColor?
	
	init( backgroundColor: UIColor?) {
		self.backgroundColor = backgroundColor
		let coloredAppearance = UINavigationBarAppearance()
		coloredAppearance.configureWithTransparentBackground()
		coloredAppearance.backgroundColor = .clear
		coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
		UINavigationBar.appearance().standardAppearance = coloredAppearance
		UINavigationBar.appearance().compactAppearance = coloredAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
		UINavigationBar.appearance().tintColor = .white

	}
	
	func body(content: Content) -> some View {
		ZStack{
			content
			VStack {
				GeometryReader { geometry in
					Color(self.backgroundColor ?? .clear)
						.frame(height: geometry.safeAreaInsets.top)
						.edgesIgnoringSafeArea(.top)
					Spacer()
				}
			}
		}
	}
}

extension View {
 
	func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
		self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
	}

}

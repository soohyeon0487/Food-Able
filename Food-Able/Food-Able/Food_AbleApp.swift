//
//  Food_AbleApp.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/05.
//

import SwiftUI

@main
struct Food_AbleApp: App {
    var body: some Scene {
        WindowGroup {
			ContentView()
				.environmentObject(UnivList())
				.environmentObject(StoreList())
        }
    }
}

//
//  WebView.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/09.
//

import SwiftUI
import WebKit

struct MyWebview: UIViewRepresentable {
   
	var urlToLoad: String
	
	func makeUIView(context: Context) -> WKWebView {
		
		guard let url = URL(string: self.urlToLoad) else {
			return WKWebView()
		}
		
		let webview = WKWebView()
		
		webview.load(URLRequest(url: url))
		
		return webview
	}
	
	func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MyWebview>) {
		   
	   }
	
}

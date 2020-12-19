//
//  MapView.swift
//  Food-Able
//
//  Created by Soohyeon Lee on 2020/12/18.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var univList: UnivList
    @EnvironmentObject var storeList: StoreList
    
    @Binding var univPickerOffset: CGFloat
    @Binding var currentRegion: MKCoordinateRegion
    
    var body: some View {
        
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
            
            // 지도 뷰
            Map(coordinateRegion: self.$currentRegion, annotationItems: self.storeList.currentList) { store in
                //MapPin(coordinate: store.region.center, tint: .green)
                MapAnnotation(coordinate: store.region.center, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Circle()
                        .strokeBorder(Color.red, lineWidth: 10)
                        .frame(width: 44, height: 44)
                }
            }
        }
        .onAppear(perform: {
            self.currentRegion = self.univList.list[self.univList.selectedUnivIndex].region
        })
    }
}


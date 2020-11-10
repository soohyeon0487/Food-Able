//
//  DataModel.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/10.
//

import MapKit
import Foundation

class University {
	var id: Int
	var name: [String] // [ kor, eng, etc ... ]
	var address: [String] // [ kor, eng, etc ... ]
	var region: MKCoordinateRegion
	
	init(id: Int, name: [String], address: [String], location: (latitude: Float, longitude: Float)) {
		self.id = id
		self.name = name
		self.address = address
		self.region = MKCoordinateRegion(center:
											CLLocationCoordinate2D(
												latitude: CLLocationDegrees(location.latitude),
												longitude: CLLocationDegrees(location.longitude)),
										 span: MKCoordinateSpan(
											latitudeDelta: 0.05,
											longitudeDelta: 0.05)
		)
	}
}

class Store {
	var id: Int
	var name: [String] // [ kor, eng, etc ... ]
	var address: [String] // [ kor, eng, etc ... ]
	var region: MKCoordinateRegion
	var likes: Int
	
	init(id: Int, name: [String], address: [String], location: (latitude: Float, longitude: Float), likes: Int) {
		self.id = id
		self.name = name
		self.address = address
		self.region = MKCoordinateRegion(center:
											CLLocationCoordinate2D(
												latitude: CLLocationDegrees(location.latitude),
												longitude: CLLocationDegrees(location.longitude)),
										 span: MKCoordinateSpan(
											latitudeDelta: 0.05,
											longitudeDelta: 0.05)
		)
		self.likes = likes
	}
}

class Food {
	var id: Int
	var name: [String] // [ kor, eng, etc ... ]
	var description: String
	var price: Int
	var likes: Int

	init(id: Int, name: [String], description: String, price: Int, likes: Int) {
		self.id = id
		self.name = name
		self.description = description
		self.price = price
		self.likes = likes
	}
}

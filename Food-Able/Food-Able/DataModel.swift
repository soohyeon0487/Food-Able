//
//  DataModel.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/10.
//

import MapKit
import Foundation

class University : Identifiable {
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

class Store : Identifiable {
	var id: Int
	var category: Int
	var name: [String] // [ kor, eng, etc ... ]
	var address: [String] // [ kor, eng, etc ... ]
	var region: MKCoordinateRegion
	var likes: Int
	
	init(id: Int, category: Int, name: [String], address: [String], location: (latitude: Float, longitude: Float), likes: Int) {
		self.id = id
		self.category = category
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

class Food : Identifiable {
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

func prepareDataForUniversity() -> [University] {
	print("prepare Fake Data for University Class")
	
	var newList = [University]()
	
	newList.append(University(id: 0, name: ["1대"], address: [""], location: (0, 0)))
	newList.append(University(id: 1, name: ["2대"], address: [""], location: (0, 0)))
	newList.append(University(id: 2, name: ["3대"], address: [""], location: (0, 0)))
	newList.append(University(id: 3, name: ["4대"], address: [""], location: (0, 0)))
	
	return newList
}


func prepareDataForStore() -> [Store] {
	print("prepare Fake Data for Store Class")
	
	var newList = [Store]()
	
	newList.append(Store(id: 0, category: 1, name: ["집밥"], address: [""], location: (0, 0), likes: 0))
	newList.append(Store(id: 1, category: 2, name: ["콩밥"], address: [""], location: (0, 0), likes: 0))
	newList.append(Store(id: 2, category: 3, name: ["약밥"], address: [""], location: (0, 0), likes: 0))
	newList.append(Store(id: 3, category: 1, name: ["쌀밥"], address: [""], location: (0, 0), likes: 0))
	
	return newList
}

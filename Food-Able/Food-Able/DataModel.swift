//
//  DataModel.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/10.
//

import MapKit
import Foundation

import SwiftyJSON
import Alamofire

class University : Identifiable {
    let id: Int
    let name: [String] // [ kor, eng, etc ... ]
    let address: [String] // [ kor, eng, etc ... ]
    let region: MKCoordinateRegion
    
    init(id: Int, name: String, address: String, location: (latitude: Double, longitude: Double, delta: Float)) {
        self.id = id
        self.name = name.split(separator: ";").map { String($0) }
        self.address = address.split(separator: ";").map { String($0) }
        self.region = MKCoordinateRegion(center:
                                            CLLocationCoordinate2D(
                                                latitude: CLLocationDegrees(location.latitude),
                                                longitude: CLLocationDegrees(location.longitude)
                                            ),
                                         span: MKCoordinateSpan(
                                            latitudeDelta: CLLocationDegrees(location.delta),
                                            longitudeDelta: CLLocationDegrees(location.delta)
                                         )
        )
    }
    
}

class UnivList: ObservableObject {
    
    @Published var list: [University] = []
    @Published var selectedUnivIndex: Int
    @Published var isComplete: Bool
    
    init() {
        self.selectedUnivIndex = 0
        self.isComplete = false
        self.loadDataForServer()
    }
    
    func loadDataForServer() {
        
        
        AF.request("http://localhost:3000/universities", method: .get).responseData { res in
            switch res.result {
            case .success:
                if let data = res.data {
                    let data = JSON(data).array!
                    
                    data.forEach {
                        let id: Int = $0["university_id"].intValue
                        let name: String = $0["university_name"].stringValue
                        let address: String = $0["university_address"].stringValue
                        let latitude: Double = $0["university_latitude"].doubleValue
                        let longitude: Double = $0["university_longitude"].doubleValue
                        
                        self.list.append(University(id: id, name: name, address: address, location: (latitude, longitude, 0.025)))
                    }
                    
                    self.isComplete = true
                }
            case .failure(_):
                print("requset error")
            }
        }
    }
    
    func getSelectedUnivRegion() -> MKCoordinateRegion {
        return self.list[self.selectedUnivIndex].region
    }
}

class Store : Identifiable {
    var id: Int
    var category: Int
    var name: [String] // [ kor, eng, etc ... ]
    var address: [String] // [ kor, eng, etc ... ]
    var description: [String]
    var phone_number: String
    var image_path: String
    var region: MKCoordinateRegion
    var likes: Int
    var univIndex: Int
    
    init(id: Int, category: Int, name: String, address: String, description: String, phone_number: String, image_path: String, location: (latitude: Float, longitude: Float, delta: Float), likes: Int, univIndex: Int) {
        self.id = id
        self.category = category
        self.name = name.split(separator: ";").map { String($0) }
        self.address = address.split(separator: ";").map { String($0) }
        self.description = description.split(separator: ";").map { String($0) }
        self.phone_number = phone_number
        self.image_path = image_path
        self.region = MKCoordinateRegion(center:
                                            CLLocationCoordinate2D(
                                                latitude: CLLocationDegrees(location.latitude),
                                                longitude: CLLocationDegrees(location.longitude)
                                            ),
                                         span: MKCoordinateSpan(
                                            latitudeDelta: CLLocationDegrees(location.delta),
                                            longitudeDelta: CLLocationDegrees(location.delta)
                                         )
        )
        self.likes = likes
        self.univIndex = univIndex
    }
}

class StoreList: ObservableObject {
    
    @Published var list: [Store] = []
    @Published var currentList: [Store] = []
    
    @Published var selectedFoodCategoryIndex: Int = 0
    
    init() {
        self.list = prepareDataForStore()
        self.currentList = self.list
    }
    
    func prepareDataForStore() -> [Store] {
        print("prepare Fake Data for Store Class")
        
        var newList = [Store]()
        
        newList.append(Store(id: 0, category: 1, name: "국밥1;Soup and Rice1", address: "", description: "", phone_number: "02-0000-0000", image_path: "store_iamge_none", location: (37.545, 127.076, 0.1), likes: 0, univIndex: 1))
        newList.append(Store(id: 1, category: 1, name: "국밥2;Soup and Rice2", address: "", description: "", phone_number: "02-0000-0000", image_path: "store_iamge_none", location: (37.556, 127.377, 0.1), likes: 0, univIndex: 1))
        newList.append(Store(id: 2, category: 2, name: "국밥3;Soup and Rice3", address: "", description: "", phone_number: "02-0000-0000", image_path: "store_iamge_none", location: (37.527, 127.178, 0.1), likes: 0, univIndex: 1))
        newList.append(Store(id: 3, category: 2, name: "국밥4;Soup and Rice4", address: "", description: "", phone_number: "02-0000-0000", image_path: "store_iamge_none", location: (37.448, 127.279, 0.1), likes: 0, univIndex: 1))
        
        return newList
    }
    
    func filteringStoreList(univ: Int) {
        switch (univ: univ, category: self.selectedFoodCategoryIndex) {
        case (0, 0):
            self.currentList = self.list
        case (0, _):
            self.currentList = self.list.filter {
                $0.category == self.selectedFoodCategoryIndex
            }
        case (_, 0):
            self.currentList = self.list.filter {
                $0.id == univ
            }
        default:
            self.currentList = self.list.filter {
                ($0.id == univ) && ($0.category == self.selectedFoodCategoryIndex)
            }
        }
    }
}

class Food : Identifiable {
    var storeID: Int
    var foodID: Int
    var name: [String] // [ kor, eng, etc ... ]
    var description: [String]
    var price: Int
    var allergyCheckList: [Bool]
    var isHALAL: Bool
    var likes: Int
    
    init(storeID: Int, foodID: Int, name: String, description: String, price: Int, allergyCheckList: String, isHALAL: Bool, likes: Int) {
        self.storeID = storeID
        self.foodID = foodID
        self.name = name.split(separator: ";").map { String($0) }
        self.description = description.split(separator: ";").map { String($0) }
        self.price = price
        self.allergyCheckList = allergyCheckList.split(separator: ";").map { Int($0) == 1 ? true : false }
        self.isHALAL = isHALAL
        self.likes = likes
    }
}
